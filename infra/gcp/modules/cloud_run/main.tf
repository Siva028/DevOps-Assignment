resource "google_cloud_run_service" "this" {
  name     = var.service_name
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = tostring(var.min_instances)
        "autoscaling.knative.dev/maxScale" = tostring(var.max_instances)
      }
    }
    spec {
      containers {
        image = var.image
        resources {
          limits = {
            memory = var.memory
          }
        }
        ports {
          container_port = var.port
        }
        env {
          name  = "NEXT_PUBLIC_API_URL"
          value = var.backend_url
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloud_run_service.this.location
  project  = google_cloud_run_service.this.project
  service  = google_cloud_run_service.this.name

  role   = "roles/run.invoker"
  member = "allUsers"
}
