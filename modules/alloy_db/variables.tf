#Global
variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "project" {}
variable "env" {}

variable "region" {
  description = "Google Cloud region"
  type        = string
}

variable "cluster_name" {
  description = "Database cluster name."
  type        = string
}

variable "network" {
  type        = string
  description = "VPC from where Cloud SQL should be accessible."
}

variable "kms_key_id" {
  type = string
  description = "KMS key ID for DB password encryption."
}

variable "automated_backup_policy" {
  type = object({
    backup_window    = string
    start_time       = string #hh:mm:ss:ns
    retention_period = string
  })

  description = "The automated backup policy for this cluster."
}

variable "primary_instance_cpu_count" {
  type        = number
  description = "The number of CPU's in the VM instance."
}

variable "read_pool_node_count" {
  type        = number
  description = "Read capacity, i.e. number of nodes in a read pool instance."
}

variable "read_pool_cpu_count" {
  type        = number
  description = "The number of CPU's in the VM instance."
}
