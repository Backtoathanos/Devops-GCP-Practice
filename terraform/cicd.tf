data "google_project" "current" {
  project_id = var.project_id
}

resource "google_service_account" "cicd" {
  project      = var.project_id
  account_id   = "github-cicd"
  display_name = "GitHub Actions CI/CD"
  description  = "Used by GitHub Actions to submit Cloud Build jobs."

  depends_on = [google_project_service.required]
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions"
  description               = "Identity pool for GitHub Actions in this repo."

  depends_on = [google_project_service.required]
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub"
  description                        = "Trust tokens from GitHub Actions OIDC."

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "assertion.repository == \"${var.github_repository}\""

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_wif" {
  service_account_id = google_service_account.cicd.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_repository}"
}

resource "google_project_iam_member" "cicd_roles" {
  for_each = toset([
    "roles/serviceusage.serviceUsageConsumer",
    "roles/cloudbuild.builds.editor",
    "roles/storage.objectAdmin",
    "roles/artifactregistry.writer",
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cicd.email}"
}

resource "google_storage_bucket_iam_member" "cicd_cloudbuild_bucket" {
  bucket = "${var.project_id}_cloudbuild"
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.cicd.email}"
}

locals {
  cloud_build_exec_roles = toset([
    "roles/artifactregistry.writer",
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/storage.objectAdmin",
  ])
}

resource "google_project_iam_member" "cloud_build_roles" {
  for_each = local.cloud_build_exec_roles

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"

  depends_on = [google_project_service.required]
}

resource "google_project_iam_member" "compute_build_roles" {
  for_each = local.cloud_build_exec_roles

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${data.google_project.current.number}-compute@developer.gserviceaccount.com"

  depends_on = [google_project_service.required]
}
