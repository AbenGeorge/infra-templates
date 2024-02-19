module "iap_setup" {
  source = "./iap_setup"

  project_id = var.project_id
  members = var.members
  network = var.network
  service_account = var.service_account
  sa_roles = var.sa_roles
  source_ranges = var.source_ranges
}

module "node_setup" {
  source = "./node_setup"

  for_each = { for nodes in var.vm_nodes : nodes.instance_name => nodes}
  project_id = var.project_id
  network = module.iap_setup.network_name
  subnetwork = var.subnetwork
  service_account = module.iap_setup.sa_id
  firewall_rule_tags = module.iap_setup.network_tags
  image = var.image
  instance_name = each.value.instance_name
  zone = each.value.zone
  enable_public_ip = each.value.enable_public_ip
  members = var.members
  startup_script = var.startup_script

  depends_on = [
    module.iap_setup
  ]
}
