# variable "organization_id" {
#   type        = string
#   description = "The id of the organization."
# }

variable "policy_type" {
  type        = string
  description = "The policy constraint type for the organization."
}

variable "policy_constraint" {
  type        = string
  description = "The policy constraint of the organization."
}

variable "policy_bool_value" {
  type        = bool
  description = "The value for boolean policy constraint of the organization."
  default     = false
}

variable "policy_list_type" {
  type        = string
  description = "The type of list policy constraint of the organization."
  default     = "allow"
}

variable "policy_list_values" {
  type        = list(string)
  description = "The values for list policy constraint of the organization."
  default     = []
}

######################
##  Test Variables  ##
######################

variable "parent" {
  type = string
  description = "The ID of the parent resource to which the policy is attached"
}

