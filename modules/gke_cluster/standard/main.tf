data "google_container_engine_versions" "version" {
  # provider = google-beta

  project        = var.project_id
  location       = var.location
  version_prefix = var.gke_version_prefix
}

resource "google_container_cluster" "gke_cluster" {
  # provider = google-beta

  project    = var.project_id
  network    = var.network
  subnetwork = var.subnetwork
  gateway_api_config {
    channel = var.gateway_api_config
  }

  name     = var.cluster_name
  location = var.location
  deletion_protection = false
  

  initial_node_count       = var.initial_node_count
  networking_mode          = "VPC_NATIVE"
  node_locations = [
    data.google_compute_zones.available.names[0]
  ]
  remove_default_node_pool = true
  enable_shielded_nodes    = true
  min_master_version       = data.google_container_engine_versions.version.latest_master_version

  release_channel {
    channel = var.release_channel
  }

  cluster_autoscaling {
    enabled = var.autoscaling_enabled
    resource_limits {
        resource_type = "cpu"
        minimum = var.minimum_cpu
        maximum = var.maximum_cpu
    } 
    resource_limits {
        resource_type = "memory"
        minimum =  var.minimum_memory
        maximum = var.maximum_memory
    } 
    auto_provisioning_defaults {
      min_cpu_platform = var.nap_min_cpu_platform
      oauth_scopes = var.nap_oauth_scopes
      service_account = data.google_service_account.node_service_account.email
      # var.gke_service_account
      # module.service_accounts.email
      # google_service_account.service_account.email
      disk_type = "pd-balanced"
    }
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_master_cidr_block
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks != null ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # workload_metadata_config {
  #   mode = "GKE_METADATA"
  # }

  logging_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
      "CONTROLLER_MANAGER",
      "SCHEDULER",
      "WORKLOADS"
    ]
  }

  monitoring_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
      "SCHEDULER",
      "CONTROLLER_MANAGER",
      "STORAGE",
      "HPA",
      "POD",
      "DAEMONSET",
      "DEPLOYMENT",
      "STATEFULSET"
    ]
  }

  network_policy {
    enabled = true
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }
  node_config {
    service_account = data.google_service_account.node_service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  # labels = var.labels
}

# resource "google_service_account" "service_account" {
#   project    = var.project_id
#   account_id = "${var.node_pool_name}-${var.env}"
# }

data "google_service_account" "node_service_account" {
  project = var.project_id
  account_id = var.gke_service_account
}

# module "service_accounts" {
#   source = "../../service_account"

#   project_id        = var.project_id
#   account_id        = "${var.node_pool_name}-${var.env}"
#   display_name      = "${var.node_pool_name}-${var.env}"
#   project_iam_roles = ["roles/container.admin"]
# }

data "google_compute_zones" "available" {
  region = var.location
  project = var.project_id
  status = "UP"
}

resource "google_container_node_pool" "gke_node_workloads" {
  # provider = google-beta

  project = var.project_id
  for_each = { for workload in var.node_workload : workload.node_pool_name => workload }

  cluster = google_container_cluster.gke_cluster.self_link

  name       = each.value.node_pool_name
  node_count = each.value.initial_node_count
  location   = data.google_compute_zones.available.names[0]

  node_config {
    disk_size_gb = each.value.db_size_gb
    disk_type    = each.value.disk_type
    machine_type = each.value.node_pool_machine_type

    service_account = data.google_service_account.node_service_account.email
    # var.gke_service_account
    # module.service_accounts.email
    # google_service_account.service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  network_config {
    enable_private_nodes = true
  }

  autoscaling {
    total_min_node_count = each.value.pool_min_node_count
    total_max_node_count = each.value.pool_max_node_count
  }
  lifecycle {
    ignore_changes = [ 
      location 
      ]
  }
  depends_on = [
    google_container_cluster.gke_cluster
  ]
}

# resource "google_container_node_pool" "gke_node_large_workloads" {
#   provider = google-beta

#   project = var.project_id

#   cluster = google_container_cluster.gke_cluster.self_link

#   name       = format("%s-large", var.node_pool_name)
#   node_count = var.initial_node_count
#   location   = var.location

#   node_config {
#     disk_size_gb = "100"
#     disk_type    = "pd-balanced"
#     machine_type = var.large_node_pool_machine_type

#     service_account = google_service_account.service_account.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }

#   network_config {
#     enable_private_nodes = true
#   }

#   autoscaling {
#     total_min_node_count = var.large_pool_min_node_count
#     total_max_node_count = var.large_pool_max_node_count
#   }

#   depends_on = [
#     google_container_cluster.gke_cluster
#   ]
# }
