
# ========================= VARIABLE DEFINITION =================== #
variable "project" {
  description = "(Required) The project ID to create the application under. ~>NOTE: GCP only accepts project ID, not project number. If you are using number, you may get a `Permission denied` error."
  type        = string
  default     = ""
}

variable "location_id" {
  description = "(Required) The location to serve the app from."
  type        = string
  default     = ""
}

variable "auth_domain" {
  description = "(Optional) The domain to authenticate users with when using App Engine's User API."
  type        = string
  default     = null
}

variable "database_type" {
  description = "(Optional) The type of the Cloud Firestore or Cloud Datastore database associated with this application. Can be `CLOUD_FIRESTORE` or `CLOUD_DATASTORE_COMPATIBILITY` for new instances."
  type        = string
  default     = "CLOUD_DATASTORE_COMPATIBILITY"

  validation {
    condition     = var.database_type == null || contains(["CLOUD_FIRESTORE", "CLOUD_DATASTORE_COMPATIBILITY"], var.database_type == null ? "" : var.database_type)
    error_message = "The database type must be one of [CLOUD_FIRESTORE, CLOUD_DATASTORE_COMPATIBILITY]."
  }
}

variable "serving_status" {
  description = "(Optional) The serving status of the app."
  type        = string
  default     = "SERVING"

  validation {
    condition     = var.serving_status == null || contains(["UNSPECIFIED", "SERVING", "USER_DISABLED", "SYSTEM_DISABLED"], var.serving_status == null ? "" : var.serving_status)
    error_message = "The serving status of the app must be one of [UNSPECIFIED, SERVING, USER_DISABLED, SYSTEM_DISABLED]."
  }
}

variable "feature_settings" {
  description = "(Optional) A block of optional settings to configure specific App Engine features."
  type = object({
    split_health_checks = bool
  })
  default = null
}

variable "iap" {
  description = "(Optional) Settings for enabling Cloud Identity Aware Proxy."
  type = object({
    oauth2_client_id     = string,
    oauth2_client_secret = string
  })
  default = null
}

# variable "domain_name" {
#   description = "(Required) Relative name of the domain serving the application."
#   type        = string
#   default     = ""
# }

# variable "ssl_settings" {
#   description = ""
#   type = object({
#     certificate_id                 = string,
#     ssl_management_type            = string,
#   })
#   default = null

#   validation {
#     condition     = var.ssl_settings != null ? ! contains([for ssl_management_type in var.ssl_settings[*].ssl_management_type : (ssl_management_type == null || contains(["AUTOMATIC", "MANUAL"], ssl_management_type)) if ssl_management_type != null], false) : true
#     error_message = "SSL management type must be one of [AUTOMATIC, MANUAL]."
#   }
# }

# variable "override_strategy" {
#   description = "(Optional) Whether the domain creation should override any existing mappings for this domain. By default, overrides are rejected. Possible values are STRICT and OVERRIDE."
#   type        = string
#   default     = null

#   validation {
#     condition     = var.override_strategy != null ? contains(["STRICT", "OVERRIDE"],var.override_strategy) : true
#     error_message = "The override strategy field must be one of [STRICT, OVERRIDE]."
#   }
# }

variable "source_range" {
  description = "Required) IP address or range, defined using CIDR notation, of requests that this rule applies to."
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = length(regexall("^([[:digit:]]{1,3}.[[:digit:]]{1,3}.[[:digit:]]{1,3}.[[:digit:]]{1,3}(/[[:digit:]]{1,2})?)$|^[*]$", var.source_range)) > 0
    error_message = "The source range must be `*` or an IP address or range specified using the CIDR notation."
  }
}

variable "action" {
  description = "(Required) The action to take if this rule matches. Possible values are UNSPECIFIED_ACTION, ALLOW, and DENY."
  type        = string
  default     = "ALLOW"

  validation {
    condition     = contains(["UNSPECIFIED_ACTION", "ALLOW", "DENY"], var.action)
    error_message = "Action must be one of [UNSPECIFIED_ACTION, ALLOW, DENY]."
  }
}

variable "description" {
  description = "(Optional) An optional string description of this rule."
  type        = string
  default     = null
}

variable "priority" {
  description = "(Optional) A positive integer that defines the order of rule evaluation. Rules with the lowest priority are evaluated first. A default rule at priority Int32.MaxValue matches all IPv4 and IPv6 traffic when no previous rule matches. Only the action of this rule can be modified by the user."
  type        = number
  default     = null

  validation {
    condition     = (var.priority == null ? 1 : var.priority) > 0
    error_message = "Prirority must be an integer number bigger than 1."
  }
}


