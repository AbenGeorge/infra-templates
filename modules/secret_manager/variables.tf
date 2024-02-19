##Global
variable "project_id" {
  description = "The GCP Project ID where secrets can be created."
  type        = string
}
variable "project" {
  description = "The Name of the project"
  type        = string
}
variable "environment" {
  description = "The Name of the project"
  type        = string
}
variable "location" {
  description = "The default location project to create resources."
  type        = string
}

##Required
variable "secret_id" {
  description = "Name of Secret,This must be unique within the project."
  type        = string
}

##Optional
variable "labels" {
  description = "The labels assigned to this Secret. Label keys must be between 1 and 63 characters long."
  type        = map(string)
  default     = {}
}
variable "kms_key_name" {
  description = "Describes the Cloud KMS encryption key that will be used to protect destination secret"
  type        = string
}
variable "secret_data_file_path" {
  description = "File path of the secret data."
  type        = string
}
