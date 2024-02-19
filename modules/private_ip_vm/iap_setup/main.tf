resource "google_project_service" "iap_service" {
  project = var.project_id
  service = "iap.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

# module "vm_service_account" {
#   source = "../../service_account"
#   account_id = var.service_account
#   display_name = "Virtual Machine SA"
#   member = 
# }

resource "google_service_account" "vm_sa" {
  project = var.project_id

  account_id   = var.service_account
  display_name = "Virtual Machine SA"
  description  = "A custom service account for GCP VM."
}



resource "google_service_account_iam_binding" "sa_user" {
  for_each = toset(var.sa_roles)
  service_account_id = google_service_account.vm_sa.id
  role               = each.value
  members            = concat(var.members,["${google_service_account.vm_sa.member}"])

  depends_on = [ 
    google_service_account.vm_sa
   ]
}

resource "google_project_iam_member" "sa_instance_admin" {
  role = "roles/compute.instanceAdmin.v1"
  project = var.project_id
  member = google_service_account.vm_sa.member

  depends_on = [ 
    google_service_account.vm_sa
   ]
}

resource "google_compute_firewall" "iap_fw" {
  project = var.project_id

  name    = var.firewall_rule_name
  network = var.network

  source_ranges = var.source_ranges

  allow {
    protocol = "tcp"
    ports = [
      "22"
    ]
  }

  target_tags = [
    "public-access-via-iap"
  ]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  depends_on = [
    google_project_service.iap_service
  ]
}

