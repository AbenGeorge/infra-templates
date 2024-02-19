variable "project_id" {
  type        = string
  description = "The id of the project."
}

variable "network_name" {
  type        = string
  description = "The name for the VPC Network."
}

variable "network_description" {
  type        = string
  description = "The description for the VPC Network."
  default     = ""
}

variable "network_routing_mode" {
  type        = string
  description = "The routing mode of the VPC Network. Allowed values, 'GLOBAL' or 'REGIONAL'."
  default     = "GLOBAL"
}

variable "network_mtu" {
  type        = number
  description = "The MTU value of the VPC Network"
  default     = 1460
}

variable "network_create_auto_subnetworks" {
  type        = bool
  description = "If true, it creates auto mode subnetworks."
  default     = false
}

variable "network_delete_default_network_routes" {
  type        = bool
  description = "If true, it deletes default network routes including Internet Gateway."
  default     = false
}

variable "psa_cidr_block" {
  type        = string
  description = "The Address allocation for Private Service Connect to connect with Google Cloud Platform resources"
  default     = ""
}

variable "subnetworks" {
  type = list(object({
    subnetwork_name                  = string
    subnetwork_description           = optional(string)
    subnetwork_region                = string
    subnetwork_purpose               = optional(string)
    subnetwork_ip_cidr_range         = string
    subnetwork_private_google_access = optional(bool)
    subnetwork_secondary_ranges      = optional(map(string))
    subnetwork_role                  = optional(string)
    subnetwork_purpose               = optional(string)
    subnetwork_log_config = optional(list(object({
      aggregation_interval = optional(string)
      flow_sampling        = optional(number)
      metadata             = optional(string)
    })))
  }))
  description = "The list of VPC Subnetworks"
}

variable "cloud_nat_config" {
  type = list(object({
    cloud_nat_name                        = string
    cloud_nat_region                      = string
    cloud_nat_advertised_subnetworks_list = list(string)
  }))
  description = "The Cloud NAT Configuration for VPC Networks"
  default     = []
}

variable "firewall" {
  type = list(object({
    name          = string
    target_tags   = list(string)
    source_ranges = list(string)
    firewall_allow = optional(list(object({
      protocol = string
      ports    = list(string)
    })))
    firewall_deny = optional(list(object({
      protocol = string
      ports    = list(string)
    })))
  }))
  description = "The firewall Configuration for VPC Networks"
  default     = []
}

variable "connector_name" {
  description = "The name of the VPC connector"
  type = string
  default = null
}

variable "connector_region" {
  description = "The region of the VPC connector"
  type = string
  default = ""
}

variable "connector_ip_cidr_range" {
  description = "The IP CIDR Range of the VPC connector"
  type = string
  default = ""
}

variable "min_throughput" {
  description = "(Optional; Default: 200) Minimum throughput of the connector in Mbps."
  type        = number
  default     = 200

  validation {
    condition     = var.min_throughput >= 200 && var.min_throughput <= 900
    error_message = "Min throughput must be within range [200,900]."
  }
}

variable "max_throughput" {
  description = "(Optional; Default: 300) Maximum throughput of the connector in Mbps, must be greater than min_throughput."
  type        = number
  default     = 300

  validation {
    condition     = var.max_throughput >= 300 && var.max_throughput <= 1000
    error_message = "Max throughput must be within range [300,1000]."
  }
}