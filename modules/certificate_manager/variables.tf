# Define your project-related variables
variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "project_id" {
  description = "The project ID of the Google Cloud project."
  type        = string
}

variable "description" {
  description = "A description for the certificate."
  type        = string
  default     = ""
}

# Define the existing public domain
variable "existing_public_domain" {
  description = "The domain for which the certificate will be issued."
  type        = string
}

variable "record_set_name" {
  type = string
  description = "The record set name used in conjunction to dns name"
}


#DNS variables

variable "dns_managed_zone" {
  description = "The DNS name of this managed zone, for instance"
  type        = string
}

