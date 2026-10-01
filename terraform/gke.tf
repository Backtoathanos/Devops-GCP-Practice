resource "google_container_cluster" "practice" {
  name     = "practice-gke"
  location = "${var.region}-a"
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  depends_on = [google_project_service.required]
}

resource "google_container_node_pool" "practice" {
  name     = "practice-pool"
  cluster  = google_container_cluster.practice.name
  location = google_container_cluster.practice.location
  project  = var.project_id

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 30
    disk_type    = "pd-balanced"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
