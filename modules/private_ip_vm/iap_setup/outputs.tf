output "network_name" {
    value = google_compute_firewall.iap_fw.network
    description = "The network to which the firewal is attached to"
}

output "sa_id" {
  value = google_service_account.vm_sa.email
  description = "The service account to be used in instance creation"
}

output "network_tags" {
  value = google_compute_firewall.iap_fw.target_tags
  description = "The target tags associated to the firewall"
}