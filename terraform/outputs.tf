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
