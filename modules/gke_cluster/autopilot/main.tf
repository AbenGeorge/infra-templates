data "google_container_engine_versions" "version" {
  provider       = google-beta
  project        = var.project_id
  location       = var.location
  version_prefix = var.gke_version_prefix
}


resource "google_container_cluster" "gke_cluster" {
  provider = google-beta

  # Enable Autopilot for this cluster
  enable_autopilot = true

  project    = var.project_id
  network    = var.network
  subnetwork = var.subnetwork

  name                = var.cluster_name
  location            = var.location
  deletion_protection = var.deletion_protection
  networking_mode     = "VPC_NATIVE"
  min_master_version  = data.google_container_engine_versions.version.latest_master_version

  release_channel {
    channel = "STABLE"
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

  # cluster_autoscaling {
  #   auto_provisioning_defaults {
  #     oauth_scopes = [
  #     "https://www.googleapis.com/auth/cloud-platform"
  #   ]
  #   min_cpu_platform = "Intel Ice Lake"
  #   }
  # }


  # dns_config {
  #   cluster_dns        = "CLOUD_DNS"
  #   cluster_dns_scope  = "CLUSTER_SCOPE"
  #   cluster_dns_domain = var.cluster_dns_domain
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

  vertical_pod_autoscaling {
    enabled = true
  }

#  node_config {
#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     service_account = var.gke_service_account
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#  }

  # node_pool_auto_config {
  #   network_tags {
  #     tags = ["foo", "bar"] # To be updated
  #   }
  # }
  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  protect_config {
    workload_vulnerability_mode = "BASIC"
  }
  security_posture_config {
    mode               = "BASIC"
    vulnerability_mode = "VULNERABILITY_BASIC"

  }
  lifecycle {
    ignore_changes = [
      min_master_version
    ]
  }
}




