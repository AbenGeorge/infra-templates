resource "google_iap_tunnel_instance_iam_member" "control_node_iap" {
  for_each = toset(var.members)

  project  = var.project_id
  instance = google_compute_instance.ansible_instance.name
  zone     = var.zone
  role     = "roles/iap.tunnelResourceAccessor"

  member = each.key

  depends_on = [
    google_compute_instance.ansible_instance
  ]
}

resource "google_iap_tunnel_instance_iam_member" "node_instance_iap" {
  for_each = toset(var.members)

  project  = var.project_id
  instance = google_compute_instance.ansible_instance.name
  zone     = var.zone
  role     = "roles/iap.tunnelResourceAccessor"

  member = "serviceAccount:${var.service_account}"

  depends_on = [
    google_compute_instance.ansible_instance
  ]
}

resource "google_compute_instance" "ansible_instance" {
  name = var.instance_name
  boot_disk {
    # source = var.source_disk
    initialize_params {
      image = var.image
      type  = var.disk_type
    }
  }
  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.project_id
    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []

      content {
        network_tier = "PREMIUM"
      }
    }
  }
  service_account {
    email  = var.service_account
    scopes = var.scopes
  }
  metadata                  = var.metadata
  metadata_startup_script   = var.startup_script
  tags                      = var.firewall_rule_tags
  deletion_protection       = var.deletion_protection
  description               = var.description
  allow_stopping_for_update = var.stop_for_updates
  zone                      = var.zone
  project                   = var.project_id
  machine_type              = var.machine_type

}
