##Global
variable "env" {}
variable "project_id" {
  description = "The name of the Project ID, the GKE cluster can be created"
  type        = string
  default     = ""
}

variable "testing_id" {
  type = string
  description = "The ID of the current setup"
}

###############
##  Project  ##
###############
variable "project_parent" {
  type = string
  description = "The parent of the GCP project"
}

variable "billing_account" {
  type = string
  description = "The billing account associated with the GCP project"
}

variable "auto_create_network" {
  type = bool
  description = "Check whether to auto create network in GCP project"
  default = false
}

variable "project_labels" {
  type = map(string)
  description = "The labels of the project."
}
variable "project_services" {
  type = list(string)
  description = "The project services enabled for project"
}

variable "iam_bindings" {
  type = list(object({
    roles    = list(string)
    member = string
  }))
  description = "Roles assigned to user to a specific project"
  default     = []
}

################
##   Network  ##
################
variable "vpc_name" {
  type        = string
  description = "The name of the vpc network."
}

variable "vpc_routing_mode" {
  type        = string
  description = "The routing mode of the vpc Network. Allowed values, 'GLOBAL' or 'REGIONAL'."
  default     = "GLOBAL"
}

variable "vpc_psa_cidr_block" {
  type        = string
  description = "The Address allocation for Private Service Connect to connect with Google Cloud Platform resources"
  default     = ""
}

variable "ip_allocation_name" {
  type        = string
  description = "The name for the global IP address range"
  default = null
}

variable "vpc_subnetworks" {
  type = list(object({
    subnetwork_name                  = string
    subnetwork_region                = string
    subnetwork_ip_cidr_range         = string
    subnetwork_private_google_access = optional(bool)
    subnetwork_secondary_ranges      = optional(map(string))
    subnetwork_role                  = optional(string)
    subnetwork_purpose               = optional(string)
    subnetwork_log_config = optional(list(object({
      aggregation_interval = optional(string)
      flow_sampling        = optional(number)
      metadata             = optional(string)
    })))
  }))
  description = "The list of vpc Subnetworks"
}

variable "vpc_nat_config" {
  type = list(object({
    cloud_nat_name                        = string
    cloud_nat_region                      = string
    cloud_nat_advertised_subnetworks_list = list(string)
  }))
  description = "The Cloud NAT Configuration for vpc Network"
  default     = []
}


###################
##  GKE Cluster  ##
###################
variable "gke_subnetwork" {
  type = string
  description = "The subnetwork used by GKE Cluster"
}

variable "gke_cluster_name" {
  description = "The name of the GKE Cluster"
  type        = string
}

variable "location" {
  description = "The location where can GKE cluster can be created."
  type        = string
}

variable "gke_version_prefix" {
  description = "The GKE version prefix"
  type        = string
  default     = "1.27."
}

variable "gateway_api_config" {
   type = string
   description = "Which Gateway Api channel should be used. CHANNEL_DISABLED, CHANNEL_EXPERIMENTAL or CHANNEL_STANDARD."
}

variable "release_channel" {
  description = "Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters"
  type = string
  default = "STABLE"
}

variable "autoscaling_enabled" {
  description = "Whether node auto-provisioning is enabled"
  type = bool
  default = true
}

variable "nap_min_cpu_platform" {
  description = "Minimum CPU platform to be used by this instance"
  type = string
  default = "AMD MILAN"
}

variable "nap_oauth_scopes" {
  description = "Scopes that are used by NAP when creating node pools."
  type = list(string)
  default = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "node_workload" {
  description = "The desired configuration optons for node workload in the GKE cluster"
  type = list(object({
    node_pool_name         = string
    initial_node_count     = number
    db_size_gb             = string
    disk_type              = string
    node_pool_machine_type = string
    pool_min_node_count    = number
    pool_max_node_count    = number
  }))
}

##Optional
variable "initial_node_count" {
  description = "The number of nodes to create in this cluster's default node pool. In regional or multi-zonal clusters, this is the number of nodes per zone"
  type        = number
  default     = 1
}

variable "labels" {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster."
  type        = map(string)
  default     = {}
}

variable "gke_master_cidr_block" {
  description = "The IP CIDR of the GKE Master"
  type        = string
}

variable "cluster_secondary_range_name" {
  description = "The name of the existing secondary range in the cluster's subnetwork to use for pod IP addresses"
  type        = string
}

variable "services_secondary_range_name" {
  description = "The name of the existing secondary range in the cluster's subnetwork to use for service"
  type        = string
}

variable "master_authorized_networks" {
  description = "The desired configuration options for master authorized networks."
  type = list(object({
    cidr_block   = optional(string)
    display_name = optional(string)
  }))
}

variable "node_pool_name" {
  type        = string
  description = "The name of GKE node pool"
}

variable "regular_node_pool_machine_type" {
  type        = string
  description = "The machine type of GKE node pool"
  default     = "n2-standard-4"
}

variable "large_node_pool_machine_type" {
  type        = string
  description = "The machine type of GKE node pool"
  default     = "n2-standard-64"
}

variable "regular_pool_min_node_count" {
  type        = number
  description = "The minimum number of nodes required"
  default     = 1
}

variable "regular_pool_max_node_count" {
  type        = number
  description = "The maximum number of nodes required"
  default     = 10
}

variable "large_pool_min_node_count" {
  type        = number
  description = "The minimum number of nodes required"
  default     = 1
}

variable "large_pool_max_node_count" {
  type        = number
  description = "The maximum number of nodes required"
  default     = 10
}

variable "minimum_cpu" {
  type        = number
  description = "The minimum CPU required for autoscaling"
  default     = 110
}

variable "maximum_cpu" {
  type        = number
  description = "The maximum CPU required for autoscaling"
  default     = 500
}

variable "minimum_memory" {
  type        = number
  description = "The minimum memory required for autoscaling"
  default     = 420
}

variable "maximum_memory" {
  type        = number
  description = "The maximum memory required for autoscaling"
  default     = 2500
}

variable "service" {
  type = string
  description = "The service that is associated to the ingress"
}

variable "namespace" {
  type = string
  description = "The namespace in which the service is present"
}

################################
##  Organizational Policies   ##
################################

variable "org_policy_constraints" {
  type = list(object({
    type        = string
    constraint  = string
    bool_value  = optional(bool)
    list_type   = optional(string)
    list_values = optional(list(string))
  }))
  description = "The organization policy constraints."
}

#################################
##  Private IP VM for Ansible  ##
#################################

variable "vm_nodes" {
  type = list(object({
    node_type =optional(string)
    instance_name = string
    image = string
    source_ranges = set(string)
    members = list(string)
    zone = string
    enable_public_ip = optional(bool)
    vm_service_account = string
    startup_script = optional(string)

  }))
}

variable "sa_roles" {
  type = list(string)
  description = "The roles attached to members linked to service account"
}

variable "instance_name" {
  type = string
  description = "The name of the instance. One of name or self_link must be provided."
}

variable "image" {
  type = string
  description = "The image from which this disk was initialised"
}


variable "source_ranges" {
  type = list(string)
  description = "If source ranges are specified, the firewall will apply only to traffic that has source IP address in these ranges."
}

variable "members" {
  type = list(string)
  description = "The acounts or group that can access the instance vis IAP"
}

variable "vm_service_account" {
  type = string
  description = "Service Account attached to VM"
}

variable "vm_subnetwork" {
  type = string
  description = "The subnetwork with which the VM is created"
}

variable "startup_script" {
  type = string
  description = "Metadata startup scripts made available within the instance."
  default = null
}



variable "policy_parent" {
  type = string
  description = "The parent resource to which the organization policy is attached"
  default = ""
}

#######################
##  Service Account  ##
#######################

variable "service_accounts" {
  type = list(object({
    account_id        = string
    display_name      = string
    role              = optional(string)
    member            = optional(string)
    project_iam_roles =  optional(list(string))
    project_services  = optional(string)
    default_iam_roles = optional(list(string))
  }))
  description = "The configuration for Service account"
}


#################
##  Cloud KMS  ##
#################
variable "kms" {
  type = list(object({
    new_ring             = bool
    keyring              = string
    key                  = string
    kms_purpose          = string
    prevent_destroy      = bool
    key_rotation_period  = string
    key_algorithm        = string
    key_protection_level = string
    kms_labels           = map(string)
    encrypters_decrypters          = string
  }))
  description = "Config for cloud KMS"
}

############################
##  Binary Authorization  ##
############################
variable "attestor-name" {
  type        = string
  description = "Name of the attestor"
}

variable "enable_binary_authorization" {
  type = bool
  default = true
}

variable "ba_key" {
  type = string
  description = "The Cloud KMS key used for binary authorization"
}

#########################
##  Artifact Registry  ##
#########################
variable "artifact_repository_id" {
  type = string
  description = "The last part of the repository name, for example: repo1"
}

variable "repo_format" {
  type = string
  description = "The format of packages that are stored in the repository. Supported formats can be found here. You can only create alpha formats if you are a member of the alpha user group."
}

########################
##  SSL Certificates  ##
########################
variable "ssl_cert_name" {
  type = string
  description = "The name of the SSL certificate"
}

variable "cert_domains" {
  type = list(string)
  description = "The list of domains secured by the ssl certificate"
}

##################
##  Kubernetes  ##
##################
variable "manifest_files" {
  type = list(string)
  description = "Location of the YAML files to be deployed in GKE"
}

#################
##  Cloud DNS  ##
#################
variable "dns_name" {
  type = string
  description = "The DNS name to be used in project"
}

variable "dns_managed_zone" {
  type = string
  description = "The DNS name of this managed zone, for instance"
}
variable "record_set_name" {
  type = string
  description = "The record set name used in conjunction to dns name"
}

#######################
##   Cloud Storage   ##
#######################
variable "storage_buckets" {
  type = list(object({
    name               = string
    storage_class      = string
    versioning_enabled = bool
    account_id         = string
    object = optional(list(object({
      object_name = string
      object_source = string 
    })))
    temporary_hold  = bool
    lifecycle_rules = list(object({
      action = any
      condition = any
    }))
  }))
  description = "The configurations for GCS Buckets"
}

variable "gcs_key_name" {
  type = string
  description = "The KMS Key associated with cloud storage"
}

#######################
##   Cloud Function  ##
#######################
variable "vpc_connector_egress_settings" {
  type = string
  description = "Available egress settings. Possible values: [VPC_CONNECTOR_EGRESS_SETTINGS_UNSPECIFIED, PRIVATE_RANGES_ONLY, ALL_TRAFFIC]"
}

variable "cf_service_accounts" {
  type = list(object({
    account_id        = string
    display_name      = string
    role              = optional(string)
    member            = optional(string)
    project_iam_roles =  optional(list(string))
    project_services  = optional(string)
    default_iam_roles = optional(list(string))
  }))
  description = "The configuration for Cloud Function Service account"
}

variable "cf_key_name" {
  type = string
  description = "The KMS Key associated with cloud function"
}
variable "source_docs" {
  type = string
  description = "The name of the bucket containing documents"
}

# variable "source_code" {
#   type = string
#   description = "The name of the bucket containing source code"
# }

variable "topic_name" {
  description = "The name of the Pub/Sub topic"
  type        = string
}

variable "sub_name" {
  type = string
  description = "The name of the subscription in google pub/sub"
}


variable "function_name" {
  description = "The name of the Cloud Function"
  type        = string
}


variable "cf_runtime" {
  description = "The runtime of the Cloud Function"
  type        = string
}

variable "entry_point" {
  description = "The entry point of the Cloud Function"
  type        = string
}

variable "min_instance_count" {
  description = "The minimum number of instances for the Cloud Function"
  type        = number
}

variable "max_instance_count" {
  description = "The maximum number of instances for the Cloud Function"
  type        = number
}

variable "available_memory" {
  description = "The available memory for the Cloud Function"
  type        = number
}

variable "timeout_seconds" {
  description = "The timeout in seconds for the Cloud Function"
  type        = number
}

variable "max_instance_request_concurrency" {
  description = "The maximum instance request concurrency for the Cloud Function"
  type        = number
}

variable "available_cpu" {
  description = "The available CPU for the Cloud Function"
  type        = string
}

variable "ingress_settings" {
  description = "The ingress settings for the Cloud Function"
  type        = string
}

variable "all_traffic_on_latest_revision" {
  description = "Whether all traffic should be routed to the latest revision of the Cloud Function"
  type        = bool
}

variable "retry_policy" {
  type = string
  description = "The retry policy to be enabled in case of failed response"
}

variable "cf_sa" {
  description = "The name of the Cloud Function service account in the module's output"
  type        = string
}

variable "event_trigger" {
  type = map(string)
  description = "A source that fires events in response to a condition in another service."
}

# variable "event_type" {
#   description = "The event type for the Cloud Function trigger"
#   type        = string
# }

###################
##  Document AI  ##
###################
variable "docai_name" {
  type = string
  description = "Display name of the Document AI processor"
}

variable "processor_type" {
  type = string
  description = "The type of processor"
}

#################################
##   CloudSQL for PostgreSQL   ##
#################################
variable "sql_database_instance_name" {
  type = string
  description = "The name of the SQL Database instance"
}

variable "postgres_root_password" {
  type = string
  description = "The password for the PostgreSQL database root user"
}

variable "csql_key_name" {
  type = string
  description = "The KMS Key associated with Cloud SQL"
}

variable "deletion_protection" {
  type = bool
  description = "Option to enable deleteion protection for the database instance"
}

variable "deletion_protection_enabled" {
  type = bool
  description = "Option to enable deleteion protection for the database instance"
}
variable "sql_database" {
  type = string
  description = "The name of the SQL Database in the instance"
}

variable "sql_user" {
  type = string
  description = "The username of the SQL user in the database"
}

variable "sql_password" {
  type = string
  description = "The password of the SQL password"
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

variable "password_validation_policy" {
  type = object({
    min_length = number
    complexity = string
    disallow_username_substring = bool
  })
  description = "Config for password validation policy"
}

# ######################
# ##  svpc connector  ##
# ######################
variable "connector_name" {
  description = "Required) The name of the resource."
  type        = string
  default = null
}

variable "connector_ip_cidr_range" {
  type = string
  description = "The IP CIDR range of the VPC connector"
  default = ""
}

# variable "svpc_subnet" {
#   type = string
#   description = "The subnetwork used for vpc connector"
# }

variable "min_throughput" {
  description = "(Optional; Default: 200) Minimum throughput of the connector in Mbps."
  type        = number
  default = 200
}

variable "max_throughput" {
  description = "(Optional; Default: 300) Maximum throughput of the connector in Mbps, must be greater than min_throughput."
  type        = number
  default = 300
}

####################
##   App Engine   ##
####################
variable "source_range" {
  description = "Required) IP address or range, defined using CIDR notation, of requests that this rule applies to."
  type        = string
}

variable "aef_service_accounts" {
  type = list(object({
    account_id        = string
    display_name      = string
    role              = optional(string)
    member            = optional(string)
    project_iam_roles =  optional(list(string))
    project_services  = optional(string)
    default_iam_roles = optional(list(string))
  }))
  description = "The configuration for App Engine Flexi Service account"
}

variable "action" {
  description = "(Required) The action to take if this rule matches. Possible values are UNSPECIFIED_ACTION, ALLOW, and DENY."
  type        = string
}

variable "description" {
  description = "(Optional) An optional string description of this rule."
  type        = string
}

variable "priority" {
  description = "(Optional) A positive integer that defines the order of rule evaluation. Rules with the lowest priority are evaluated first. A default rule at priority Int32.MaxValue matches all IPv4 and IPv6 traffic when no previous rule matches. Only the action of this rule can be modified by the user."
  type        = number
}


variable "ae_runtime" {
  description = "(Required; Default: python) The runtime that will be used by App Engine. Supported runtimes are: python27, python37, python38, java8, java11, php55, php73, php74, ruby25, go111, go112, go113, go114, nodejs10, nodejs12."
  type        = string
  default     = "python"

}


variable "app_service" {
  description = "(Required; Default: default) Name of the App Engine Service"
  type        = string
}

variable "service_version" {
  description = "(Optional) Name of the App Engine version of the Service that will be deployed."
  type        = string
}

variable "instance_class" {
  description = "(Optional; Default: F1) Instance class that is used to run this version. Valid values are AutomaticScaling: F1, F2, F4, F4_1G BasicScaling or ManualScaling: B1, B2, B4, B4_1G, B8 Defaults to F1 for AutomaticScaling and B2 for ManualScaling and BasicScaling. If no scaling is specified, AutomaticScaling is chosen."
  type        = string
}

variable "zip" {
  description = "(Optional) Zip File Structure."
  type = string
  # object({
  #   source_url  = string,
  #   files_count = number
  # })
  default = null
}

# variable "entrypoint" {
#   description = "(Optional) The entrypoint for the application."
#   type = object({
#     shell = string
#   })
#   default = null
# }

variable "cpu_utilization" {
  description = "(Required) Target scaling by CPU usage."
  type = list(object({
    target_utilization        = number
    aggregation_window_length = optional(string)
  }))
}

variable "max_concurrent_requests" {
  description = "(Optional) Number of concurrent requests an automatic scaling instance can accept before the scheduler spawns a new instance."
  type        = number

}

variable "max_total_instances" {
  description = "(Optional; Default 20) Maximum number of instances that should be started to handle requests for this version."
  type        = number

}

variable "min_total_instances" {
  description = "(Optional; Default 2) Minimum number of running instances that should be maintained for this version."
  type        = number
 
}

variable "domain" {
  description = "(Optional) Domain name to match against."
  type        = string
}

variable "path" {
  description = "(Required; Default: /*) Pathname within the host. Must start with a `/`. A single `*` can be included at the end of the path."
  type        = string
}

####################
##   Cloud Build  ##
####################
variable "gitlab_pat_api" {
   type = string
   description = "The ID of the gitlab api token"
  
}

variable "gitlab_api_token" {
  type = string
  description = "The Personal Access Token for API of the repository"
}

variable "gitlab_pat_read" {
  type = string
  description = "The Unique ID of Gitlab Read API Token"
  
}

variable "gitlab_read_api_token" {
  type = string
  description = "The Personal Access Token for READ API of the repository"
  
}

variable "webhook_secret" {
    type = string
    description = "The ID of the Gitlab Webhook Token"
}

variable "webhook_secret_value" {
    type = string
    description = "The Personal Access Token for Webhook of the repository"
}

variable "connection_name" {
    type = string
    description = "Immutable. The resource name of the connection, in the format projects/{project}/locations/{location}/connections/{connection_id}."
}

variable "host_uri" {
    type = string
    description = "the URI of the GitLab Enterprise host this connection is for"
}

variable "ssl_ca" {
    type = string
    description = "SSL certificate to use for requests to GitLab Enterprise"
}

variable "repo_name" {
    type = string
    description = "The name of the repository"
}

variable "remote_uri" {
    type = string
    description = "Git Clone HTTPS URI."
}

variable "gitlab_cloudbuild_name" {
    type = string
    description = "Name of the trigger. Must be unique within the project"
}

variable "gsr_cloudbuild_name" {
    type = string
    description = "Name of the trigger. Must be unique within the project"
}

variable "trigger_description" {
    type = string
    description = "Human-readable description of the trigger"
}

variable "tags" {
    type = list(string)
    description = "Tags for annotation of a BuildTrigger"
}

variable "filename" {
    type = string
    description = "Path, from the source root, to a file whose contents is used for the template. Either a filename or build template must be provided. Set this only when using trigger_template or github."
}

variable "gsr_trigger_config" {
    type = map(object({
      branch_regex = string
      project_id = optional(string)
      repo_name = optional(string)
        }))
    description = ""
}

variable "gitlab_trigger_config" {
    type = map(object({
      branch_regex = string
        }))
    description = ""
}

variable "dir" {
    type = string
    description = "Directory, relative to the source root, in which to run the build. This must be a relative path. If a step's dir is specified and is an absolute path, this value is ignored for that step's execution."
}

variable "invert_regex" {
    type = bool
    description = "Only trigger a build if the revision regex does NOT match the revision regex."
}

variable "project_number" {
  type = string
  description = "The project number of GCP project"
}

variable "gitlab_repo" {
  type = string
  description = "The url of gitlab if unable to create via terraform"
}














