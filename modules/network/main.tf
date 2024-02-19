resource "google_compute_network" "network" {
  project                         = var.project_id
  name                            = var.network_name
  description                     = var.network_description
  routing_mode                    = var.network_routing_mode
  mtu                             = var.network_mtu
  auto_create_subnetworks         = var.network_create_auto_subnetworks
  delete_default_routes_on_create = var.network_delete_default_network_routes
}

resource "google_compute_subnetwork" "subnetwork" {
  project = var.project_id
  network = google_compute_network.network.id

  for_each = { for subnetwork in var.subnetworks : subnetwork.subnetwork_name => subnetwork }

  name                     = each.key
  description              = lookup(each.value, "subnetwork_description", "")
  region                   = each.value.subnetwork_region
  role                     = each.value.subnetwork_role
  ip_cidr_range            = each.value.subnetwork_ip_cidr_range
  purpose                  = lookup(each.value, "subnetwork_purpose", "PRIVATE_RFC_1918")
  private_ip_google_access = lookup(each.value, "subnetwork_private_google_access", true)

  dynamic "secondary_ip_range" {
    for_each = length(lookup(each.value, "subnetwork_secondary_ranges") != null ? each.value.subnetwork_secondary_ranges : {}) > 0 ? {
      for range_name, ip_cidr_range in each.value.subnetwork_secondary_ranges : range_name => ip_cidr_range
    } : {}

    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }

  dynamic "log_config" {
    for_each = length(lookup(each.value, "subnetwork_log_config") != null ? toset(each.value.subnetwork_log_config) : []) == 1 ? [
      for log_config in each.value.subnetwork_log_config : log_config
    ] : []

    content {
      aggregation_interval = lookup(log_config.value, "aggregation_interval") != null ? log_config.value.aggregation_interval : "INTERVAL_5_SEC"
      flow_sampling        = lookup(log_config.value, "flow_sampling") != null ? log_config.value.flow_sampling : 0.5
      metadata             = lookup(log_config.value, "metadata") != null ? log_config.value.metadata : "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_address" "nat_address" {
  project = var.project_id

  for_each = { for nat_config in var.cloud_nat_config : nat_config.cloud_nat_name => nat_config }

  name         = format("%s-address", each.key)
  region       = each.value.cloud_nat_region
  address_type = "EXTERNAL"

  depends_on = [
    google_compute_network.network
  ]
}

resource "google_compute_router" "router" {
  project = var.project_id
  network = google_compute_network.network.id

  for_each = { for nat_config in var.cloud_nat_config : nat_config.cloud_nat_name => nat_config }

  name   = format("%s-router", each.key)
  region = each.value.cloud_nat_region

  bgp { 
    asn            = 64514
    advertise_mode = "CUSTOM"
    dynamic "advertised_ip_ranges" {
      for_each = [
        for subnetwork_name in each.value.cloud_nat_advertised_subnetworks_list : google_compute_subnetwork.subnetwork[subnetwork_name].ip_cidr_range
      ]

      content {
        range = advertised_ip_ranges.value
      }
    }
  }

  depends_on = [
    google_compute_network.network
  ]
}

resource "google_compute_router_nat" "router_nat" {
  project = var.project_id

  for_each = { for nat_config in var.cloud_nat_config : nat_config.cloud_nat_name => nat_config }

  name                               = each.value.cloud_nat_name
  region                             = each.value.cloud_nat_region
  router                             = google_compute_router.router[each.key].name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  nat_ips = [
    google_compute_address.nat_address[each.key].id
  ]

  dynamic "subnetwork" {
    for_each = [
      for subnetwork_name in each.value.cloud_nat_advertised_subnetworks_list : google_compute_subnetwork.subnetwork[subnetwork_name].self_link
    ]

    content {
      name                    = subnetwork.value
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  log_config {
    enable = true
    filter = "ALL"
  }

  depends_on = [
    google_compute_network.network,
    google_compute_router.router
  ]
}
resource "google_compute_firewall" "firewall" {
  for_each      = { for firewall in var.firewall : firewall.name => firewall }
  name          = each.value.name
  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
  project       = var.project_id
  network       = google_compute_network.network.name

  dynamic "allow" {
    for_each = length(lookup(each.value, "firewall_allow") != null ? toset(each.value.firewall_allow) : []) == 1 ? [
      for allow in each.value.firewall_allow : allow
    ] : []
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = length(lookup(each.value, "firewall_deny") != null ? toset(each.value.firewall_deny) : []) == 1 ? [
      for deny in each.value.firewall_deny : deny
    ] : []
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  depends_on = [
    google_compute_network.network
  ]
}

resource "google_compute_global_address" "psa_cidr_block" {
  provider = google-beta
  count    = var.psa_cidr_block != "" && var.psa_cidr_block != null ? 1 : 0

  project       = var.project_id
  name          = format("%s-psa-cidr", var.network_name)
  purpose       = "VPC_PEERING"
  address       = var.psa_cidr_block
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 20
  network       = google_compute_network.network.id
}

resource "google_service_networking_connection" "psa" {
  count = var.psa_cidr_block != "" && var.psa_cidr_block != null ? 1 : 0

  network = google_compute_network.network.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.psa_cidr_block[0].name
  ]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  count = var.psa_cidr_block != "" && var.psa_cidr_block != null ? 1 : 0

  project = var.project_id
  peering = google_service_networking_connection.psa[0].peering
  network = google_compute_network.network.name

  import_custom_routes = true
  export_custom_routes = true
}

resource "google_vpc_access_connector" "serverless_vpc_connector" {
  count = var.connector_name != "" && var.connector_name != null ? 1 : 0
  name           = var.connector_name
  project        = var.project_id
  region         = var.connector_region
  ip_cidr_range  = var.connector_ip_cidr_range
  network        = google_compute_network.network.id
  min_throughput = (var.min_throughput < var.max_throughput) == true ? var.min_throughput : "The min_throughput value should be smaller than min_throughput"
  max_throughput = (var.max_throughput > var.min_throughput) == true ? var.max_throughput : "The max_throughput value should be bigger than max_throughput"

  depends_on = [ 
    google_compute_subnetwork.subnetwork,
    google_compute_network.network
   ]
}
