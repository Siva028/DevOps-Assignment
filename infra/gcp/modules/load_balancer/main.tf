resource "google_compute_region_network_endpoint_group" "frontend_neg" {
  name                  = "frontend-neg-prod"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.frontend_service_name
  }
}
resource "google_compute_region_network_endpoint_group" "backend_neg" {
  name                  = "backend-neg-prod"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.backend_service_name
  }
}
resource "google_compute_backend_service" "frontend_backend" {
  name                  = "frontend-backend-prod"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group = google_compute_region_network_endpoint_group.frontend_neg.id
  }
}

resource "google_compute_backend_service" "backend_backend" {
  name                  = "backend-backend-prod"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  backend {
    group = google_compute_region_network_endpoint_group.backend_neg.id
  }
}
resource "google_compute_url_map" "this" {
  name = "pgagi-url-map-prod"

  default_service = google_compute_backend_service.frontend_backend.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.frontend_backend.id

    path_rule {
      paths   = ["/api/*"]
      service = google_compute_backend_service.backend_backend.id
    }
  }
}
resource "google_compute_target_http_proxy" "this" {
  name    = "pgagi-http-proxy-prod"
  url_map = google_compute_url_map.this.id
}
resource "google_compute_global_forwarding_rule" "this" {
  name       = "pgagi-forwarding-rule-prod"
  target     = google_compute_target_http_proxy.this.id
  port_range = "80"
}

