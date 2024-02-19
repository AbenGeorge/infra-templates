output "record_name_to_insert" {
  value = google_certificate_manager_dns_authorization.dns_auth.dns_resource_record.0.name
}

output "record_type_to_insert" {
  value = google_certificate_manager_dns_authorization.dns_auth.dns_resource_record.0.type
}

output "record_data_to_insert" {
  value = google_certificate_manager_dns_authorization.dns_auth.dns_resource_record.0.data
}

output "ssl_cert" {
  value = google_certificate_manager_certificate_map.certificate_map.id
}

output "ssl_policy_id" {
  value = google_compute_ssl_policy.ssl_policy.id
}
