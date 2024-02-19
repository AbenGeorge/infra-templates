variable "project_parent" {
  type        = string
  description = "The parent to the project."
}

variable "project_id" {
  type        = string
  description = "The id of the project."
}

variable "billing_account" {
  type        = string
  description = "The billing account linked to the project."
}

variable "project_name" {
  type        = string
  description = "The name of the project."
  default     = ""
}

variable "auto_create_network" {
  type        = bool
  description = "The default VPC network gets created if it set to \"true\"."
  default     = false
}

variable "project_labels" {
  type        = map(string)
  description = "The labels of the project."
  default     = {}
}


variable "project_services" {
  type        = list(string)
  description = "The Google Project services"
  default     = []
}

variable "is_shared_vpc_host" {
  type        = bool
  description = "If true, the project could be configured as shared vpc host."
  default     = false
}

variable "host_project_id" {
  type        = string
  description = "The project id of the shared vpc host for service projects."
  default     = ""
}

variable "monitoring_project_id" {
  type        = string
  description = "The project id of the monitoring project for monitored projects."
  default     = ""
}

variable "iam_bindings" {
  type = list(object({
    roles    = list(string)
    member = string
  }))
  description = "Role assigned to users to a specific project"
  default     = []
}
