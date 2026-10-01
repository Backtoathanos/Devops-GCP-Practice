output "service_url" {
  description = "Public URL of the Cloud Run service."
  value       = google_cloud_run_v2_service.hello.uri
}

output "artifact_registry" {
  description = "Docker repository path for pushing images."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}

output "image" {
  description = "Image currently configured on the service."
  value       = var.image
}

output "workload_identity_provider" {
  description = "WIF provider resource name for GitHub Actions auth."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "cicd_service_account" {
  description = "Service account GitHub Actions impersonates."
  value       = google_service_account.cicd.email
}

output "gke_cluster" {
  description = "GKE cluster name."
  value       = google_container_cluster.practice.name
}

output "gke_location" {
  description = "Zone of the practice GKE cluster."
  value       = google_container_cluster.practice.location
}

output "gke_get_credentials" {
  description = "Command that points kubectl at the practice cluster."
  value       = "gcloud container clusters get-credentials ${google_container_cluster.practice.name} --zone ${google_container_cluster.practice.location} --project ${var.project_id}"
}
