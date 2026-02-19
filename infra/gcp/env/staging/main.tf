module "artifact_registry" {
  source    = "../../modules/artifact_registry"
  region    = var.region
  repo_name = var.repository_name
}

locals {
  backend_image  = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_name}/backend:${var.image_tag}"
  frontend_image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_name}/frontend:${var.image_tag}"
}
module "backend" {
  source        = "../../modules/cloud_run"
  service_name  = "pgagi-backend-staging"
  region        = var.region
  image         = local.backend_image
  port          = 8000
  min_instances = 1
  max_instances = 3
}


module "frontend" {
  source        = "../../modules/cloud_run"
  service_name  = "pgagi-frontend-staging"
  region        = var.region
  image         = local.frontend_image
  port          = 3000
  min_instances = 1
  max_instances = 3
  backend_url   = module.backend.url
}

