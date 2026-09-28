variable "project_id" {
  description = "GCP project that hosts the practice platform."
  type        = string
}

variable "region" {
  description = "Region for Artifact Registry and Cloud Run."
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Cloud Run service name."
  type        = string
  default     = "hello-app"
}

variable "repository_id" {
  description = "Artifact Registry Docker repository id."
  type        = string
  default     = "hello-repo"
}

variable "image" {
  description = "Container image already pushed to Artifact Registry."
  type        = string
}

variable "container_port" {
  description = "Port the container listens on. Cloud Run sets PORT to this value."
  type        = number
  default     = 8080
}

variable "allow_unauthenticated" {
  description = "If true, the service is publicly invokable."
  type        = bool
  default     = true
}

variable "github_repository" {
  description = "GitHub repo allowed to impersonate the CI/CD service account. Format: owner/name."
  type        = string
  default     = "Backtoathanos/Devops-GCP-Practice"
}
