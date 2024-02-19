variable "account_id" {
  type        = string
  description = "The account id for service account"
  default = ""
}

variable "display_name" {
  type        = string
  description = "The display name for service account"
  default = ""
}

variable "project_id" {
  type        = string
  description = "The Google project ID"
}

variable "role" {
  type        = string
  description = "The role for an IAM member"
  default = null
}

variable "member" {
  type        = string
  description = "The IAM Member"
  default = null
}

variable "project_iam_roles" {
  type        = list(string)
  description = "The role for an IAM member"
  default = []
}

variable "project_iam_members" {
  type        = string
  description = "The IAM Member"
  default = null
}

variable "project_services" {
  type = string
  description = "The services for which the service accounts are automatically created"
  default = ""
}

variable "default_iam_roles" {
  type        = list(string)
  description = "The role for an default IAM member"
  default = []
}