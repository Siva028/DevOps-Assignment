resource "google_artifact_registry_repository" "this" {
  location      = var.region
  repository_id = var.repo_name
  format        = "DOCKER"
}
