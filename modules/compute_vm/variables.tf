#Global
variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "project" {}
variable "env" {}

variable "vpc_project_id" {
  type        = string
  description = "Project ID of the where the VPC exists.(For shared VPC)"
}

variable "region" {
  description = "Google Cloud region"
  type        = string
}

variable "zone" {
  description = "The zone where the Google Compute Engine instance will be located."
  type        = string
}

variable "subnetwork" {
  type        = string
  description = "The id of Subnetwork."
}
# Instance variables
variable "instance_name" {
  description = "The name of the Google Compute Engine instance."
  type        = string
}

variable "machine_type" {
  description = "The machine type for the Google Compute Engine instance."
  default     = "n2-standard-2"
  type        = string
}

variable "image" {
  description = "The image to be used for the boot disk."
  default     = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230727"
  type        = string
}

variable "boot_disk_size" {
  description = "The size of the boot disk in GB."
  default     = 10
  type        = number
}

variable "boot_disk_type" {
  description = "The type of the boot disk."
  default     = "pd-balanced"
  type        = string
}

variable "labels" {
  description = "Labels for instance."
  type        = map(string)
  default     = {}
}

variable "network_tags" {
  type        = set(string)
  description = "Network tags for the bastion host."
}

variable "metadata_startup_script" {
  type        = string
  description = "Metadata startup script for the instance."
  default     = ""
}

variable "enable_public_ip" {
  type        = bool
  description = "Set to true if VM needs to have public IP"
  default     = false
}

variable "additional_disk" {
  type = map(object({
    size = number
    type = string
  }))
  description = "Additional Disk for VM."
  default     = null
}

variable "ssh_pub_keys" {
  type        = list(string)
  description = "SSH key to connect to the instances. Format: [\"<username>:<pub-key-content>\"]"
  default     = []
}

variable "spot_instance" {
  type        = bool
  description = "Set to true of instance needs to be an Spot instance."
  default     = false
}

variable "project_iam_roles" {
  type        = list(any)
  description = "The list of IAM permissions to be allowed within the instance."
}
