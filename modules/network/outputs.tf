output "project_id" {
  description = "The project id of the VPC network"
  value       = google_compute_network.network.project
}

output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.network.name
}

output "network_id" {
  description = "The id of the VPC network"
  value       = google_compute_network.network.id
}

output "network_self_link" {
  description = "The self link of the VPC network"
  value       = google_compute_network.network.self_link
}

output "network_routing_mode" {
  description = "The routing mode of the VPC network"
  value       = google_compute_network.network.routing_mode
}

output "subnetworks" {
  description = "The subnetworks of the VPC Network"
  value = [
    for subnetwork in google_compute_subnetwork.subnetwork : {
      name                  = subnetwork.name
      region                = subnetwork.region
      ip_cidr_range         = subnetwork.ip_cidr_range
      google_private_access = subnetwork.private_ip_google_access
    }
  ]
}

output "cloud_nat_config" {
  description = "The Cloud NAT Config for the VPC Network"
  value = [
    for nat_config in var.cloud_nat_config : {
      cloud_nat_name                        = google_compute_router_nat.router_nat[nat_config.cloud_nat_name].name
      cloud_nat_region                      = google_compute_router_nat.router_nat[nat_config.cloud_nat_name].region
      cloud_nat_router_name                 = google_compute_router.router[nat_config.cloud_nat_name].name
      cloud_nat_address_name                = google_compute_address.nat_address[nat_config.cloud_nat_name].name
      cloud_nat_address                     = google_compute_address.nat_address[nat_config.cloud_nat_name].address
      cloud_nat_advertised_subnetworks_list = flatten([for bgp in google_compute_router.router[nat_config.cloud_nat_name].bgp : [for range in bgp.advertised_ip_ranges : range.range]])
    }
  ]
}
