variable "project_id" {
  type = string
  description = "The ID of the project in which the resource belongs"
}

variable "service_account" {
  type = string
  description = "The service account to attach to the instance."
}

variable "sa_roles" {
  type = list(string)
  description = "The roles attached to members linked to service account"
}

variable "firewall_rule_name" {
  type = string
  description = "Name of the firewall to be attached to the network for IAP"
  default = "iap-access-firewall"
}

variable "network" {
  type = string
  description = "The name or self_link of the network attached to this interface"
}

variable "source_ranges" {
  type = set(string)
  description = "If source ranges are specified, the firewall will apply only to traffic that has source IP address in these ranges."
}

variable "members" {
  type = list(string)
  description = "The acounts or group that can access the instance vis IAP"
}








