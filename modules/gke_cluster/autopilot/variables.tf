##Global
variable "project" {}
variable "env" {}

variable "project_id" {
  description = "The name of the Project ID, the GKE cluster can be created"
  type        = string
  default     = ""
}

variable "network" {
  description = "The id of the VPC network to host the cluster in (required)"
  type        = string
}

variable "subnetwork" {
  description = "The id of the subnetwork to host the cluster in (required)"
  type        = string
}

#Required
variable "cluster_name" {
  description = "The name of the GKE Cluster"
  type        = string
}


variable "deletion_protection" {
  description = "Protection agianst the deletion of GKE Cluster"
  type        = bool
  default     = false
}

variable "location" {
  description = "The location where can GKE cluster can be created."
  type        = string
}

variable "gke_version_prefix" {
  description = "The GKE version prefix"
  type        = string
  default     = "1.27."
}

variable "cluster_dns_domain" {
  type        = string
  description = "The domain name used for dns with the cluster workloads."
  default = null
}


variable "labels" {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster."
  type        = map(string)
  default     = {}
}

variable "gke_master_cidr_block" {
  description = "The IP CIDR of the GKE Master"
  type        = string
}

variable "cluster_secondary_range_name" {
  description = "The name of the existing secondary range in the cluster's subnetwork to use for pod IP addresses"
  type        = string
}

variable "services_secondary_range_name" {
  description = "The name of the existing secondary range in the cluster's subnetwork to use for service"
  type        = string
}

variable "master_authorized_networks" {
  description = "The desired configuration options for master authorized networks."
  type = list(object({
    cidr_block   = optional(string)
    display_name = optional(string)
  }))
}

variable "gke_service_account" {
  type = string
  description = "The Google Cloud Platform Service Account to be used by the node VMs."
}

variable "autoscaling_enabled" {
  description = "Whether node auto-provisioning is enabled"
  type        = bool
  default     = true
}

variable "nap_min_cpu_platform" {
  description = "Minimum CPU platform to be used by this instance"
  type        = string
  default     = "Intel Ivy Bridge"
}

variable "nap_oauth_scopes" {
  description = "Scopes that are used by NAP when creating node pools."
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "minimum_cpu" {
  type        = number
  description = "The minimum CPU required for autoscaling"
  default     = 110
}

variable "maximum_cpu" {
  type        = number
  description = "The maximum CPU required for autoscaling"
  default     = 500
}

variable "minimum_memory" {
  type        = number
  description = "The minimum memory required for autoscaling"
  default     = 420
}

variable "maximum_memory" {
  type        = number
  description = "The maximum memory required for autoscaling"
  default     = 2500
}

