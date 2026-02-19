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
  service_name  = "pgagi-backend-production"
  region        = var.region
  image         = local.backend_image
  port          = 8000
  min_instances = 2
  max_instances = 10
}


module "frontend" {
  source        = "../../modules/cloud_run"
  service_name  = "pgagi-frontend-production"
  region        = var.region
  image         = local.frontend_image
  port          = 3000
  min_instances = 2
  max_instances = 10
  backend_url   = module.backend.url
}

module "load_balancer" {
  source = "../../modules/load_balancer"

  region                = var.region
  frontend_service_name = "pgagi-frontend-production"
  backend_service_name  = "pgagi-backend-production"
}
