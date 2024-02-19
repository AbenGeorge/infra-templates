variable "project_id" {
  type = string
  description = "The ID of the project in which the resource belongs"
}

variable "network" {
  type = string
  description = "The name or self_link of the network attached to this interface"
}

variable "members" {
  type = list(string)
  description = "The acounts or group that can access the instance vis IAP"
}

variable "zone" {
  type = string
  description = "The zone of the instance."
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

variable "service_account" {
  type = string
  description = "The service account to attach to the instance."
}

variable "firewall_rule_tags" {
  type = set(string)
  description = "The firewall tags that is attached to the instance"
}

variable "enable_public_ip" {
  type        = bool
  description = "Set to true if VM needs to have public IP"
  default     = false
}