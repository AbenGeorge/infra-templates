##############################
# Unmanaged Instance Group  #
##############################
resource "google_compute_instance_group" "instance_group" {
  project = var.project_id
  name    = "${var.name}-${var.project}-${var.env}"
  zone    = var.zone

  instances = [
    var.instance_id
  ]

  dynamic "named_port" {
    for_each = var.named_port != null ? var.named_port : {}
    content {
      name = named_port.key
      port = named_port.value
    }
  }
}

resource "google_compute_backend_service" "backend_service" {
  name                  = "${var.name}-${var.project}-${var.env}-public"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  project               = var.project_id
  protocol              = "HTTP"

  health_checks = [
    google_compute_health_check.health_check.id
  ]

  timeout_sec = 30
  port_name   = var.port_name

  backend {
    group = google_compute_instance_group.instance_group.id
  }

  log_config {
    enable      = true
    sample_rate = 1
  }
}

resource "google_compute_health_check" "health_check" {
  name               = "${var.name}-${var.project}-${var.env}-public"
  project            = var.project_id
  timeout_sec        = 5
  check_interval_sec = 10
  tcp_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_global_address" "static_ip" {
  name         = "${var.name}-${var.project}-${var.env}"
  address_type = "EXTERNAL" # EXTERNAL for an external IP address
  project      = var.project_id
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  project               = var.project_id
  name                  = "${var.name}-${var.project}-${var.env}-public"
  ip_protocol           = "TCP" # IP protocol for the rule
  ip_address            = google_compute_global_address.static_ip.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = var.port_range
  target                = google_compute_target_https_proxy.https_proxy.id
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name            = "${var.name}-${var.project}-${var.env}-public"
  project         = var.project_id
  certificate_map = "//certificatemanager.googleapis.com/${var.certificate_map}"
  ssl_policy      = var.ssl_policy
  url_map         = google_compute_url_map.url_map.id
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.name}-${var.project}-${var.env}-public"
  project         = var.project_id
  default_service = google_compute_backend_service.backend_service.id
  host_rule {
    hosts = [
      var.domain_name
    ]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.backend_service.id
    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.backend_service.id
    }
  }
}
