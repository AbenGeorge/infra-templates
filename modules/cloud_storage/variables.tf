variable "name" {
  type        = string
  description = "The storage bucket name"
}

variable "location" {
  type        = string
  description = "The storage bucket location"
}

variable "project_id" {
  type        = string
  description = "Project ID in which bucket should be created "
}

variable "versioning" {
  type        = bool
  description = "Enable or disable object versioning for the bucket."
  default     = false
}

variable "storage_class" {
  type        = string
  description = "Class of storage for the bucket"
  default     = "STANDARD"
}

variable "force_destroy" {
  type = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run "
  default = true
}

variable "public_access_prevention" {
  type = string
  description = "Enables uniform bucket-level access on a bucket"
  default = "enforced"
}

variable "uniform_bucket_level_access" {
  type = bool
  description = "Enables uniform bucket-level access on a bucket."
  default = true
}

variable "google_storage_sa" {
  type = string
  description = "The service account used to access storage bucket"
}

variable "object" {
  type = list(object({
    object_name = string
    object_source = string
  }))
  description = "The config of the object present in the bucket"
  default = []
}

variable "encryption" {
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
  type = object({
    default_kms_key_name = string
  })
  default = null
}

variable "lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type = list(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.
    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.
    action = any

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.
    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.
    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.
    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition
    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
    condition = any
  }))
  default = []
}

variable "temporary_hold" {
  type = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects."
  default = true
}