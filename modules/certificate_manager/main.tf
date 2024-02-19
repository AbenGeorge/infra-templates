resource "google_certificate_manager_dns_authorization" "dns_auth" {
  name    = "${var.project}-${var.env}-dns-auth" # Unique name for the DNS authorization
  domain  = "${var.record_set_name}.${var.existing_public_domain}"          # Specify the domain for authorization
  
  project = var.project_id                       # Set the Google Cloud project ID
}

resource "google_certificate_manager_certificate" "certificate" {
  name        = "${var.project}-${var.env}-certificate" # Unique name for the certificate
  project     = var.project_id
  description = var.description # Description for the certificate

  managed {
    domains = [
      "${var.record_set_name}.${var.existing_public_domain}" # Specify wildcard domain for the certificate
    ]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.dns_auth.id # Link DNS authorization to the certificate
    ]
  }
}

resource "google_certificate_manager_certificate_map" "certificate_map" {
  name    = "${var.project}-${var.env}-certificate-map" # Unique name for the certificate map
  project = var.project_id
}

resource "google_certificate_manager_certificate_map_entry" "certificate_map_entry" {
  name         = "${var.project}-${var.env}-certificate-map-entry"               # Unique name for the certificate map entry
  map          = google_certificate_manager_certificate_map.certificate_map.name # Link to the certificate map
  certificates = [google_certificate_manager_certificate.certificate.id]
  project      = var.project_id
  hostname     = "${var.record_set_name}.${var.existing_public_domain}"
}

data "google_dns_managed_zone" "dns_managed_zone" {
  project = var.project_id
  name    = var.dns_managed_zone
}

resource "google_dns_record_set" "records" {
  project      = var.project_id
  managed_zone = data.google_dns_managed_zone.dns_managed_zone.name

  name = google_certificate_manager_dns_authorization.dns_auth.dns_resource_record.0.name
  type = google_certificate_manager_dns_authorization.dns_auth.dns_resource_record.0.type
  ttl  = 60

  rrdatas = [google_certificate_manager_dns_authorization.dns_auth.dns_resource_record.0.data]
}

resource "google_compute_ssl_policy" "ssl_policy" {
  project         = var.project_id
  name            = "${var.project}${var.env}sslpolicy"
  min_tls_version = "TLS_1_2" # Minimum TLS version for the SSL policy
  profile         = "MODERN"
}
