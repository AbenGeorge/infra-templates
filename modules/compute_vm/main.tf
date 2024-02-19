resource "google_service_account" "service_account" {
  project    = var.project_id
  account_id = "${var.instance_name}-${var.project}-${var.env}"
}

resource "google_project_iam_member" "iam_bindings" {
  for_each = toset(var.project_iam_roles)

  project = var.project_id
  role    = each.value
  member  = format("serviceAccount:%s", google_service_account.service_account.email)
}

####################
# Compute Instance #
####################
resource "google_compute_instance" "instance" {
  project      = var.project_id
  name         = "${var.instance_name}-${var.project}-${var.env}"
  zone         = var.zone
  machine_type = var.machine_type

  allow_stopping_for_update = true
  boot_disk {

    auto_delete = true

    initialize_params {
      image = var.image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  network_interface {

    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []

      content {
        network_tier = "PREMIUM"
      }
    }
  }

  dynamic "scheduling" {
    for_each = var.spot_instance ? [1] : []

    content {
      preemptible                 = true
      provisioning_model          = "SPOT"
      automatic_restart           = false
      instance_termination_action = "STOP"
    }
  }

  tags = var.network_tags

  metadata_startup_script = var.metadata_startup_script

  service_account {
    email  = google_service_account.service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  dynamic "attached_disk" {
    for_each = var.additional_disk != null ? var.additional_disk : {}
    content {
      source = attached_disk.key
    }
  }

  metadata = {
    "ssh-keys" = join("\n", var.ssh_pub_keys)
  }

  labels = var.labels

  depends_on = [google_compute_disk.persistent_disk]
}

#####################
# Persistent Disk #
#####################
resource "google_compute_disk" "persistent_disk" {
  for_each = var.additional_disk != null ? var.additional_disk : {}

  project = var.project_id
  zone    = var.zone

  name = each.key
  type = each.value.type
  size = each.value.size
}
