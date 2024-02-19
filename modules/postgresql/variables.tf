variable "project_id" {
  type        = string
  description = "The Google Project ID"
}


variable "network_id" {
  type        = string
  description = "The ID of the Network where VM is being created"
}

variable "sql_database_instance_name" {
  type        = string
  description = "The Name of the Cloud SQL Instance"
}

variable "postgres_root_password" {
  type        = string
  description = "The password of `postgres` user in the Cloud SQL Instance"
  sensitive   = true
  default = ""
}

variable "region" {
  type        = string
  description = "The location of the project resources being created"
}

variable "ip_allocation_name" {
  type        = string
  description = "The name for the global IP address range"
}


variable "database_version" {
  description = "Database version to use"
  type        = string
  default     = "POSTGRES_14"
}

variable "sql_user" {
  type        = string
  description = "The SQL Database User"
}

variable "sql_database" {
  type        = string
  description = "The SQL Database"
}


variable "sql_password" {
  type        = string
  description = "The SQL Database Password"
  sensitive   = true
  default = ""
}

variable "deletion_protection" {
  description = "Protection against deleting SQL instance"
  type        = bool
  default     = false
}

variable "deletion_protection_enabled" {
  description = "Protection against deleting SQL instance"
  type        = bool
  default     = false
}

variable "kms_key_name" {
  type = string
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
}

variable "tier" {
  description = "The tier for Cloud SQL instance"
  type        = string
  default     = "db-custom-2-8192"
}

variable "availability_type" {
  description = "The availability type for the Cloud SQL instance"
  type        = string
  default     = "REGIONAL"
}

variable "disk_size" {
  description = "The disk size for the Cloud SQL instance"
  type        = number
  default     = 10
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size"
  type        = bool
  default     = true
}

variable "disk_type" {
  description = "The disk type for the Cloud SQL instance"
  type        = string
  default     = "PD_SSD"
}

variable "connector_enforcement" {
  type = string
  description = "Specifies if connections must use Cloud SQL connectors"
}

variable "authorized_networks" {
  type = object({
    name = string
    value = string
    expiration_time = string
  })
  description = "Network ip authorized to access SQL instance"
}

variable "backup_retention_count" {
  description = "The number of backups to retain in Cloud SQL backup configuration."
  type        = number
  default     = 8
}

variable "backup_start_time" {
  description = "HH:MM format time indicating when backup configuration starts."
  type        = string
  default     = "16:40"
}

variable "maintenance_window_day" {
  description = "Day of week (1-7), starting on Monday"
  type        = number
  default     = 1
}

variable "maintenance_window_hour" {
  description = "Hour of day (0-23), ignored if day not set"
  type        = number
  default     = 17
}

variable "password_validation_policy" {
  type = object({
    min_length = number
    complexity = string
    disallow_username_substring = bool
  })
  description = "Config for password validation policy"
}

