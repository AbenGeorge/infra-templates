data "external" "whatismyip" {
  program = ["/bin/bash", "shell-scripts/whatsmyip.sh"]
}

###############
##  Project  ##
###############
# module "main_project" {
#   source = "./modules/project"

#   project_parent = var.project_parent
#   project_id     = var.project_id
#   project_name   = var.project_id
#   #Billing account ID obtained from "common.hcl"
#   billing_account = var.billing_account
#   #auto create network setting obtained from "common.hcl"
#   auto_create_network = var.auto_create_network
#   project_labels = var.project_labels


#   project_services = var.project_services
#   iam_bindings     = var.iam_bindings
# }


################
##   Network  ##
################
module "vpc_network" {
  source = "./modules/network"

  project_id           = var.project_id
  network_name         = "${var.testing_id}-vpc"
  network_routing_mode = var.vpc_routing_mode
  psa_cidr_block       = var.vpc_psa_cidr_block != "" ? var.vpc_psa_cidr_block : null
  subnetworks = [
    for subnetwork in var.vpc_subnetworks : {
      subnetwork_name                  = subnetwork.subnetwork_name
      subnetwork_region                = subnetwork.subnetwork_region
      subnetwork_ip_cidr_range         = subnetwork.subnetwork_ip_cidr_range
      subnetwork_private_google_access = subnetwork.subnetwork_private_google_access
      subnetwork_log_config            = lookup(subnetwork, "subnetwork_log_config", [])
      subnetwork_secondary_ranges      = lookup(subnetwork, "subnetwork_secondary_ranges", {})
      subnetwork_role                  = lookup(subnetwork, "subnetwork_role", null)
      subnetwork_purpose               = lookup(subnetwork, "subnetwork_purpose", null)
    }
  ]

  connector_name          = var.connector_name
  connector_region        = var.location
  connector_ip_cidr_range = var.connector_ip_cidr_range
  min_throughput          = var.min_throughput
  max_throughput          = var.max_throughput

  cloud_nat_config = var.vpc_nat_config != null && var.vpc_nat_config != "" ? [
    for nat_config in var.vpc_nat_config : {
      cloud_nat_name                        = nat_config.cloud_nat_name
      cloud_nat_region                      = nat_config.cloud_nat_region
      cloud_nat_advertised_subnetworks_list = nat_config.cloud_nat_advertised_subnetworks_list
    }
  ] : []
  # depends_on = [
  #   module.main_project
  # ]
}

####################################
##  Private IP VM/ Ansible nodes  ##
####################################
# module "private_ip_vm_nodes" {
#   source = "./modules/private_ip_vm"

#   project_id      = var.project_id
#   image           = var.image
#   network         = module.vpc_network.network_self_link
#   sa_roles        = var.sa_roles
#   subnetwork      = module.vpc_network.subnetworks[0].name
#   service_account = var.vm_service_account
#   source_ranges   = concat(var.source_ranges, [module.vpc_network.subnetworks[0].ip_cidr_range])
#   members         = var.members
#   startup_script  = var.startup_script
#   vm_nodes        = var.vm_nodes

#   depends_on = [
#     module.vpc_network
#   ]
# }


############################
##  GKE Standard Cluster  ##
############################
module "gke_standard_cluster" {
  source = "./modules/gke_cluster/standard"

  # Product specific values
  project = var.project_id
  env     = var.env

  project_id = var.project_id
  location   = var.location
  network    = module.vpc_network.network_name
  subnetwork = module.vpc_network.subnetworks[0].name
  gke_service_account = local.terraform_service_account

  cluster_name                  = "${var.testing_id}-cluster"
  gateway_api_config            = var.gateway_api_config
  gke_master_cidr_block         = var.gke_master_cidr_block
  minimum_cpu                   = var.minimum_cpu
  minimum_memory                = var.minimum_memory
  cluster_secondary_range_name  = var.cluster_secondary_range_name
  services_secondary_range_name = var.services_secondary_range_name
  master_authorized_networks = flatten([[
    {
      cidr_block   = format("%s/%s", data.external.whatismyip.result["internet_ip"], 24)
      display_name = "deployer_cidr"
    }
  ], var.master_authorized_networks])
  node_pool_name     = "${var.testing_id}-node-pool"
  node_workload      = var.node_workload
  initial_node_count = 1
  depends_on = [
    module.vpc_network
  ]
}

# module "https_target_proxy" {
#   source    = "./modules/map_to_ingress"
#   namespace = var.namespace
#   service   = var.service
# }

#############################
##  GKE Autopilot Cluster  ##
#############################
# module "gke_autopilot_cluster" {
#   source = "./modules/gke_cluster/autopilot"

#   project = var.project_id
#   env     = var.env

#   project_id                    = var.project_id
#   location                      = var.location
#   network                       = module.vpc_network.network_id
#   subnetwork                    = module.vpc_network.subnetworks[0].name
#   cluster_name                  = var.gke_cluster_name
#   gke_master_cidr_block         = var.gke_master_cidr_block
#   cluster_secondary_range_name  = var.cluster_secondary_range_name
#   services_secondary_range_name = var.services_secondary_range_name
#   master_authorized_networks    = var.master_authorized_networks
#   depends_on = [
#     module.vpc_network
#   ]
# }


##################################
##  Organizational Constraints  ##
##################################
# module "org_policy_constraints" {
#   source = "./modules/org_policy"

#   for_each = {
#     for policy_constraint in var.org_policy_constraints : policy_constraint.constraint => policy_constraint
#   }

#   parent    = var.project_id
#   policy_type        = each.value.type
#   policy_constraint  = each.value.constraint
#   policy_bool_value  = each.value.bool_value
#   policy_list_type   = each.value.list_type
#   policy_list_values = each.value.list_values
# }


###############################
##   Custom Service Account  ##
###############################
# module "service_accounts" {
#   source = "./modules/service_account"

#   for_each = {
#     for sa in var.service_accounts : sa.account_id => sa
#   }

#   project_id        = var.project_id
#   account_id        = each.value.account_id
#   display_name      = each.value.display_name
#   role              = each.value.role
#   member            = each.value.member
#   project_iam_roles = each.value.project_iam_roles
#   project_services  = each.value.project_services
#   default_iam_roles = each.value.default_iam_roles

#   depends_on = [
#     module.main_project
#   ]
# }

###################
##   Cloud KMS   ##
###################
# module "cloud_kms" {
#   source = "./modules/cloud_kms"

#   for_each = {
#     for kms in var.kms : kms.key => kms
#   }
#   new_ring             = each.value.new_ring
#   keyring              = each.value.new_ring ? each.value.keyring : format("projects/%s/locations/%s/keyRings/%s", var.project_id, var.location, each.value.keyring)
#   project_id           = module.vpc_network.project_id
#   location             = var.location
#   keys                 = each.value.key
#   prevent_destroy      = each.value.prevent_destroy
#   purpose              = each.value.kms_purpose
#   key_rotation_period  = each.value.key_rotation_period
#   key_algorithm        = each.value.key_algorithm
#   key_protection_level = each.value.key_protection_level
#   labels               = each.value.kms_labels
#   encrypters_decrypters = [
#     "serviceAccount:${module.service_accounts[each.value.encrypters_decrypters].email}",
#     # module.service_accounts[each.value.encrypters_decrypters].default_email == null ? "serviceAccount:service-${module.main_project.project_number}@gs-project-accounts.iam.gserviceaccount.com" : "serviceAccount:${module.service_accounts[each.value.encrypters_decrypters].default_email}"
#   ]

#   depends_on = [
#     module.vpc_network,
#     module.service_accounts,
#     module.main_project
#   ]

# }

############################
##  Binary Authorization  ##
############################
# module "binary_authorization_attestor" {
#   source = "./modules/binary_authorization/attestator"

#   enable_binary_authorization = var.enable_binary_authorization
#   project_id                = var.project_id
#   gke_cluster               = module.gke_autopilot_cluster.name
#   kms_crypto_key_version_id = tostring(module.cloud_kms[var.ba_key].key_id)
#   attestor-name             = var.attestor-name
#   location                  = var.location

#   depends_on = [
#     module.cloud_kms,
#     module.gke_autopilot_cluster,
#     module.main_project
#   ]
# }

#########################
##  Artifact Registry  ##
#########################
# module "artifact_registry" {
#   source = "./modules/artifact_registry"

#   project_id             = var.project_id
#   artifact_repository_id = var.artifact_repository_id
#   repo_format            = var.repo_format
#   env = {
#     "env" = var.env
#   }
#   location = var.location
# }

#####################
#  K8s Deployment  ##
#####################
# module "kubernetes_deployment" {
#   source    = "./modules/k8s"
#   for_each  = toset(var.manifest_files)
#   yaml_body = file("k8s-manifests/gateway-api/${each.key}")

#   depends_on = [
#     module.gke_standard_cluster,
#     # module.ssl_certificate
#   ]
# }

#######################
#  SSL Certificates  ##
#######################
# module "ssl_certificate" {
#   source = "./modules/certificate"

#   project_id    = var.project_id
#   ssl_cert_name = var.ssl_cert_name
#   cert_domains  = var.cert_domains
# }

#################
##  Cloud DNS  ##
#################
# module "cloud_dns" {
#   source          = "./modules/cloud_dns"
#   project_id      = var.project_id
#   dns_name        = var.dns_name
#   record_set_name = var.record_set_name
#   location        = var.location
#   cluster_name    = "${var.testing_id}-cluster"
#   dns_labels      = var.project_labels

#   depends_on = [module.kubernetes_deployment]
# }

###########################
##  Certificate Manager  ##
###########################
# module "certificate_manager" {
#   source = "./modules/certificate_manager"

#   project_id             = var.project_id
#   project                = var.testing_id
#   env                    = var.env
#   record_set_name = var.record_set_name
#   existing_public_domain = var.dns_name
#   dns_managed_zone = var.dns_managed_zone

#   depends_on = [ module.kubernetes_deployment ]
# }

##################
##  Compute VM  ##
##################


#####################
## Storage Buckets ##
#####################
# module "storage_buckets" {
#   source                             = "./modules/cloud_storage"

#   for_each                           = {
#     for bucket in var.storage_buckets: bucket.name => bucket
#   }

#   name                               = format("%s-${random_id.server.hex}",each.value.name)
#   project_id                         = module.vpc_network.project_id
#   google_storage_sa                  = module.service_accounts[each.value.account_id].email 
#   location                           = upper(var.location)
#   storage_class                      = lookup(each.value, "storage_class") != null && lookup(each.value, "storage_class") != "" ? lookup(each.value, "storage_class")     : "STANDARD"
#   versioning                         = lookup(each.value, "versioning_enabled") != null && lookup(each.value, "versioning_enabled") != "" ? lookup(each.value, "versioning_enabled"): false
#   encryption = {
#     default_kms_key_name = module.cloud_kms[var.gcs_key_name].key_id
#   }
#   temporary_hold = each.value.temporary_hold
#   lifecycle_rules = each.value.lifecycle_rules
#   object                             = lookup(each.value, "object") != null ? [for object in each.value.object: {
#     object_name = object.object_name
#     object_source = object.object_source
#   } ] : []


#   depends_on = [ 
#     module.main_project,
#     module.cloud_kms,
#     module.service_accounts
#    ]
# }

# module "cloud_function_gitlab_build" {
#   source = "./modules/cloud_build"
#   gitlab_enabled = false
#   project_id = var.project_id
#   region = var.location
#   gitlab_repo = var.gitlab_repo
#   gitlab_pat_api = var.gitlab_pat_api
#   gitlab_api_token = var.gitlab_api_token
#   gitlab_pat_read = var.gitlab_pat_read
#   gitlab_read_api_token = var.gitlab_read_api_token
#   webhook_secret = var.webhook_secret
#   webhook_secret_value = var.webhook_secret_value
#   project_number =  var.project_number
#   connection_name = var.connection_name
#   host_uri =  var.host_uri
#   ssl_ca = var.ssl_ca
#   repo_name = var.repo_name
#   remote_uri = var.remote_uri
#   cloudbuild_name = var.gitlab_cloudbuild_name
#   trigger_description = var.trigger_description 
#   tags = var.tags
#   filename = var.filename
#   trigger_config = var.gitlab_trigger_config
# }

# module "cloud_function_gsr_build" {
#   source = "./modules/cloud_build"
#   gitlab_enabled = false
#   project_id = var.project_id
#   region = var.location
#   project_number = var.project_number
#   cloudbuild_name = var.gsr_cloudbuild_name
#   trigger_description = var.trigger_description
#   tags = var.tags
#   filename = var.filename
#   trigger_config = var.gsr_trigger_config
#   dir =  var.dir
#   invert_regex = var.invert_regex
# }

#######################
##   Cloud Function  ##
#######################
# module "cloud_function" {
#   source                           = "./modules/event_triggered_function"

#   project_id                       = module.vpc_network.project_id
#   default_sa                       = var.cf_service_accounts
#   project_number                   = module.main_project.project_number
#   kms_key_name = tostring(module.cloud_kms[var.cf_key_name].key_id)
#   vpc_connector = module.vpc_network.connector_self_link
#   vpc_connector_egress_settings = var.vpc_connector_egress_settings
#   # storage_bucket_code              = module.storage_buckets[var.source_code].name
#   # storage_bucket_code_object       = module.storage_buckets[var.source_code].object_id[0]
#   # source_repo_name = "https://source.developers.google.com/projects/prj-icici-26/repos/github_abengeorge-searce_document-ai-in-gcp/moveable-aliases/master/paths/Document-processing-function/"
#   # source_branch_name = "master"
#   storage_bucket_docs              = module.storage_buckets[var.source_docs].name
#   topic_name                       = var.topic_name
#   sub_name                         = var.sub_name
#   name                             = format("%s-${random_id.server.hex}",var.function_name)
#   location                         = var.location
#   runtime                          = var.cf_runtime
#   entry_point                      = var.entry_point
#   min_instance_count               = var.min_instance_count
#   max_instance_count               = var.max_instance_count
#   available_memory                 = var.available_memory
#   timeout_seconds                  = var.timeout_seconds
#   max_instance_request_concurrency = var.max_instance_request_concurrency 
#   available_cpu                    = var.available_cpu
#   ingress_settings                 = var.ingress_settings
#   all_traffic_on_latest_revision   = var.all_traffic_on_latest_revision
#   cf_service_account               = module.service_accounts[var.cf_sa].email
#   trigger_region                   = var.location
#   retry_policy                     = var.retry_policy
#   event_trigger = var.event_trigger


#   depends_on                       = [ 
#     module.main_project,
#     module.vpc_network,
#     module.service_accounts,
#     module.cloud_kms,
#     module.storage_buckets
#    ]
# }

###################
##  Document AI  ##
###################
# module "documentai" {
#   source         = "./modules/document_ai"

#   display_name   = format("%s-${random_id.server.hex}",var.docai_name)
#   processor_type = var.processor_type
#   project_id     = var.project_id

#   depends_on     = [ 
#     module.main_project,
#     module.vpc_network,
#     module.service_accounts,
#     module.cloud_kms,
#     module.storage_buckets,
#    ]
# }

################################
### Cloud SQL for PostgreSQL ###
################################
# module "postgresql" {
#   source                     = "./modules/postgresql"

#   network_id                 = module.vpc_network.network_self_link
#   project_id                 = module.vpc_network.project_id
#   sql_database_instance_name = format("%s-${random_id.server.hex}",var.sql_database_instance_name)
#   kms_key_name = tostring(module.cloud_kms[var.csql_key_name].key_id)
#   connector_enforcement = var.connector_enforcement
#   authorized_networks = var.authorized_networks
#   postgres_root_password     = base64encode(var.postgres_root_password)
#   region                     = var.location
#   deletion_protection        = var.deletion_protection
#   deletion_protection_enabled = var.deletion_protection_enabled
#   sql_database               = var.sql_database
#   sql_user                   = var.sql_user
#   sql_password               = base64encode(var.sql_password)
#   ip_allocation_name         = var.ip_allocation_name
#   password_validation_policy = var.password_validation_policy

#   depends_on                 = [ 
#     module.documentai,
#     module.main_project,
#     module.vpc_network,
#     module.cloud_kms,
#     module.cloud_function,
#     module.storage_buckets,
#    ]
# }


####################
##   App Engine   ##
####################
# module "app" {
#   source = "./modules/app_engine/app"

#   project      = var.project_id
#   location_id  = var.location
#   source_range = var.source_range
#   action       = var.action
#   description  = var.description
#   priority     = var.priority

#   depends_on = [ 
#     module.main_project, 
#     module.cloud_function,
#     module.cloud_kms,
#     module.documentai,
#     module.service_accounts,
#     module.postgresql,
#     module.vpc_network,
#     module.storage_buckets,
#    ]

# }


# module "app_engine_flexible" {
#   source          = "./modules/app_engine/app_version"


#   runtime         = var.ae_runtime
#   default_sa = var.aef_service_accounts
#   project_id      = var.project_id
#   ae_service_account = module.service_accounts["icici-gc-ae-sa"].email
#   service         = var.app_service
#   service_version = format("%s-${random_id.server.hex}",var.service_version)
#   network         = {
#     forwarded_ports  = null
#     instance_tag     = null
#     name             = module.vpc_network.network_name
#     subnetwork       = module.vpc_network.subnetworks[1].name
#     session_affinity = null
#   }
#   instance_class          = var.instance_class
#   beta_settings           = { cloud_sql_instances      : module.postgresql.connection_name }
#   env_variables           = { CLOUD_SQL_CONNECTION_NAME: module.postgresql.connection_name, DB_USER: var.sql_user, DB_PASS: base64encode(var.sql_password), DB_NAME: module.postgresql.name, DB_HOST: format("%s: 5432",module.postgresql.instance_ip_address) }
#   zip                     = {
#     source_url = "https://storage.googleapis.com/${module.storage_buckets[var.zip].name}/${module.storage_buckets[var.zip].object_id[0]}"  #"https://storage.googleapis.com/${var.project_id}.appspot.com/${module.storage_buckets[var.zip].object_id[0]}" #"https://storage.googleapis.com/prj-icici-14.appspot.com/${module.storage_buckets[var.zip].object_id[0]}"  #"https://storage.googleapis.com/${var.project_id}.appspot.com/${module.storage_buckets[var.zip].object_id[0]}"
#     files_count = 1
#   }
#   max_concurrent_requests = var.max_concurrent_requests
#   cpu_utilization         = var.cpu_utilization
#   min_total_instances     = var.min_total_instances
#   max_total_instances     = var.max_total_instances
#   domain                  = var.domain
#   path                    = var.path

#   depends_on = [
#     module.main_project,
#     module.app, 
#     module.cloud_function,
#     module.cloud_kms,
#     module.documentai,
#     module.service_accounts,
#     module.postgresql,
#     module.vpc_network,
#     module.storage_buckets,
#   ]
# }
