resource "google_compute_managed_ssl_certificate" "default" {
  name = var.ssl_cert_name
  project = var.project_id

  managed {
    domains = var.cert_domains
  }
}