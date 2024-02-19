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

variable "zone" {
  type = string
  description = "The zone of the instance."
  default = "europe-west1-a"
}

variable "instance_name" {
  type = string
  description = "The name of the instance. One of name or self_link must be provided."
  default = "value"
}

# variable "source_disk" {
#   type = string
#   description = "The name or self_link of the disk attached to this instance"
# }

variable "image" {
  type = string
  description = "The image from which this disk was initialised"
}


variable "disk_type" {
  type = string
  description = "The Google Compute Engine disk type. Such as pd-standard, pd-ssd or pd-balanced."
  default = "pd-standard"
}

variable "subnetwork" {
  type = string
  description = "The name or self_link of the subnetwork attached to this interface."
}

variable "scopes" {
  type = list(string)
  description = "A list of service scopes."
  default = ["cloud-platform"]
}

variable "metadata" {
  type = map(string)
  description = "Metadata key/value pairs made available within the instance."
  default = null
}

variable "startup_script" {
  type = string
  description = "Metadata startup scripts made available within the instance."
  default = null
}

variable "deletion_protection" {
  type = bool
  description = "Whether deletion protection is enabled on this instance."
  default = false
}

variable "description" {
  type = string
  description = "A brief description of the resource"
  default = "Test VM instance"
}

variable "stop_for_updates" {
  type = bool
  description = "If true, allows Terraform to stop the instance to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail."
  default = true
}

variable "machine_type" {
  type = string
  description = "The machine type to create."
  default = "e2-medium"
}

variable "vm_nodes" {
  type = list(object({
    instance_name = string
    image = optional(string)
    zone = string
    startup_script = optional(string)
    enable_public_ip = optional(bool)

  }))
  default = []
}
