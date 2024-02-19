variable "project_id" {
  type = string
  description = "The project ID of the cloud Pub/Sub"
}

variable "project_number" {
  type = string
  description = "The project number of the cloud Pub/Sub"
}

variable "default_sa" {
  type = list(object({
    account_id        = string
    display_name      = string
    role              = optional(string)
    member            = optional(string)
    project_iam_roles =  optional(list(string))
    project_services  = optional(string)
    default_iam_roles = optional(list(string))
  }))
  description = "The configuration for Default Service account"
}

variable "kms_key_name" {
  type = string
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
}

variable "name" {
  description = "The name of the Cloud Function"
  type        = string
  default     = "gcf-function"
}

variable "location" {
  description = "The location of the Cloud Function"
  type        = string
  default     = "us-central1"
}

# variable "storage_bucket_code" {
#   type = string
#   description = "The ID of the bucket ie source code"
# }

# variable "storage_bucket_code_object" {
#   type = string
#   description = "The ID of the bucket object ie source code"
# }

variable "source_repo_name" {
  type = string
  description = "The Cloud Source Repository containing Cloud Function Source Code"
}

# variable "source_branch_name" {
#   type = string
#   description = "The Cloud Source Repository branch containing Cloud Function Source Code"
# }


variable "storage_bucket_docs" {
  type = string
  description = "The ID of the bucket ie source docs"
}


variable "topic_name" {
  type = string
  description = "The name of the topic in google pub/sub"
}

variable "sub_name" {
  type = string
  description = "The name of the subscription in google pub/sub"
}

variable "description" {
  description = "The description of the Cloud Function"
  type        = string
  default     = "a new function"
}

variable "runtime" {
  description = "The runtime of the Cloud Function"
  type        = string
  default     = "nodejs16"
}

variable "entry_point" {
  description = "The entry point of the Cloud Function"
  type        = string
  default     = "helloPubSub"
}

variable "max_instance_count" {
  description = "The maximum instance count of the Cloud Function"
  type        = number
  default     = 3
}

variable "min_instance_count" {
  description = "The minimum instance count of the Cloud Function"
  type        = number
  default     = 1
}

variable "vpc_connector" {
  type = string
  description = "The Serverless VPC Access connector that this cloud function can connect to"
}

variable "vpc_connector_egress_settings" {
  type = string
  description = "Available egress settings. Possible values: [VPC_CONNECTOR_EGRESS_SETTINGS_UNSPECIFIED, PRIVATE_RANGES_ONLY, ALL_TRAFFIC]"
}

variable "available_memory" {
  description = "The available memory of the Cloud Function"
  type        = number
  default     = 4096
}

variable "timeout_seconds" {
  description = "The timeout in seconds of the Cloud Function"
  type        = number
  default     = 60
}

variable "max_instance_request_concurrency" {
  description = "The maximum instance request concurrency of the Cloud Function"
  type        = number
  default     = 80
}

variable "available_cpu" {
  description = "The available CPU of the Cloud Function"
  type        = string
  default     = "4"
}

variable "ingress_settings" {
  description = "The ingress settings of the Cloud Function"
  type        = string
  default     = "ALLOW_INTERNAL_ONLY"
}

# variable "all_traffic_on_latest_revision" {
#   description = "Whether all traffic should be routed to the latest revision of the Cloud Function"
#   type        = bool
#   default     = true
# }

variable "event_trigger" {
  type        = string
  description = "A source that fires events in response to a condition in another service."
}

variable "trigger_region" {
  description = "The trigger region of the Cloud Function event"
  type        = string
  default     = "us-central1"
}

variable "retry_policy" {
  type = bool
  description = "The retry policy to be enabled in case of failed response"
}

# variable "event_type" {
#   description = "The event type of the Cloud Function trigger"
#   type        = string
#   default     = "google.cloud.pubsub.topic.v1.messagePublished"
# }

variable "cf_service_account" {
  type = string
  description = "The sevice account used for Cloud Functions"
}
