project_id                       = "ce-ps-3team"
env                           = "internal"
node_pool_name = "pool-1"
location                      = "europe-west1"
testing_id = "sql-svr-containr"

###############
##  Project  ##
###############
project_parent = "folders/240221061252"
billing_account = "01DCF6-E8150A-687930"
auto_create_network = false
project_labels = {
  "owner" = "aben-dot-george-at-searce-dot-com"
  "environment" = "sql-svr-containr"
}
project_services = [
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "compute.googleapis.com",
    "certificatemanager.googleapis.com",
#     # "documentai.googleapis.com",
#     # "eventarc.googleapis.com",
#     # "sqladmin.googleapis.com",
#     "servicenetworking.googleapis.com",
#     "serviceusage.googleapis.com",
#     # "cloudfunctions.googleapis.com",
#     # "cloudbuild.googleapis.com",
#     # "pubsub.googleapis.com",
#     # "vpcaccess.googleapis.com",
#     # "artifactregistry.googleapis.com",
    "container.googleapis.com",
#     # "containerscanning.googleapis.com",
#     # "ondemandscanning.googleapis.com",
#     # "run.googleapis.com",
#     # "appengineflex.googleapis.com",
#     "secretmanager.googleapis.com",
#     # "appengine.googleapis.com",
    "domains.googleapis.com",
#     # "binaryauthorization.googleapis.com",
#     # "containeranalysis.googleapis.com",
#     # "cloudkms.googleapis.com",

  ]

iam_bindings = [ 
  {
  member = "aben.george@searce.com"
  roles = [ 
    "roles/editor",
    # "roles/viewer",
    "roles/resourcemanager.projectIamAdmin",
    "roles/container.admin",
  ]
  }, 
]

###################
##  VPC Network  ##
###################
vpc_name =  "sql-svr-containr-vpc"
vpc_subnetworks = [ 
  # {
  #   subnetwork_name = "private-ip-vm-subnet"
  #   subnetwork_ip_cidr_range = "10.0.1.0/24"
  #   subnetwork_region = "europe-west1"
  #   subnetwork_private_google_access = true
  # },
  {
    subnetwork_name = "gke-subnet-pvt"
    subnetwork_ip_cidr_range = "10.0.2.0/24"
    subnetwork_region = "europe-west1"
    subnetwork_secondary_ranges = {
      "pods" = "10.212.128.0/17"
      "services" = "10.213.0.0/22"
    }
    subnetwork_private_google_access = true
  }, 
  # {
  #   subnetwork_name = "proxy-only-pvt"
  #   subnetwork_ip_cidr_range = "10.0.0.0/24"
  #   subnetwork_role = "ACTIVE"
  #   subnetwork_purpose = "REGIONAL_MANAGED_PROXY"
  #   subnetwork_region = "europe-west1"
  # } 
  ]
vpc_nat_config = [ 
  # {
  # cloud_nat_name = "pvt-ip-vm-nat-gw"
  # cloud_nat_region = "europe-west1"
  # cloud_nat_advertised_subnetworks_list = [ "private-ip-vm-subnet" ]
  # },
  {
  cloud_nat_name = "gke-nat-gw"
  cloud_nat_region = "europe-west1"
  cloud_nat_advertised_subnetworks_list = [ "gke-subnet-pvt" ]
  }  
]

###################
##  GKE Cluster  ##
###################

gke_subnetwork = "gke-subnet-pvt"
gke_cluster_name                  = "sql-svr-containr-cluster"
gke_master_cidr_block         = "10.0.10.0/28"
cluster_secondary_range_name  = "pods"
gateway_api_config = "CHANNEL_STANDARD"
services_secondary_range_name = "services"
master_authorized_networks = [
  {
    cidr_block   = "192.140.152.0/24"
    display_name = "public_cidr"
  }
]
node_workload = [ {
  node_pool_name = "pool-1"
  initial_node_count = 1
  db_size_gb = "10"
  disk_type = "pd-balanced"
  node_pool_machine_type = "n2-standard-4"
  pool_min_node_count = 1
  pool_max_node_count = 2
} ]
namespace = "default"
service = "nginx"

##############################
## Organization Constraints ##
##############################
org_policy_constraints = [
  # {
  #   type       = "bool"
  #   constraint = "compute.skipDefaultNetworkCreation"
  #   bool_value = true
  # },
  # {
  #   type       = "list",
  #   constraint = "compute.vmExternalIpAccess",
  #   list_type  = "deny"
  # },
  {
    type = "list",
    # This list policy constraint don't support 'deny' option.
    constraint = "iam.allowedPolicyMemberDomains",
    list_type  = "allow"
    # TODO: Add Directory Customer IDs to be allowed
    list_values = [
      "C03qna2pp", # polygonlabs.cloud
    ]
  },
  {
    # Geographic restrictions for resource location
    type       = "list"
    constraint = "constraints/gcp.resourceLocations"
    list_type  = "allow"
    list_values = [
      "in:europe-west2-locations",     # London
      "in:asia-northeast3-locations",  # Seoul
      "in:europe-west6-locations",     # Zurich
      "in:europe-west3-locations",     # Frankfurt (PoSV1 snapshots)
      "in:europe-southwest1-locations" # Madrid (zkEVM)
    ]
  }
]

#################################
##  Private IP VM for Ansible  ##
#################################
instance_name = "ansible-vm-1"
image = "ubuntu-os-cloud/ubuntu-2204-lts"
vm_subnetwork = "private-ip-vm-subnet"
sa_roles = [ 
  "roles/iam.serviceAccountUser",
  "roles/iam.serviceAccountTokenCreator",
 ]
vm_service_account = "pvt-vm-sa"
source_ranges = [ 
  "35.235.240.0/20",
  "10.0.1.0/24" 
  ]
members = [ 
  "user:aben.george@searce.com"
]
startup_script = ""
# " #! /bin/bash \n sudo apt update \n wget https://bootstrap.pypa.io/get-pip.py \n python3 ./get-pip.py \n python3 -m pip install -r requirements.txt \n python3 -m pip install yamllint \n sudo apt-get install software-properties-common \n sudo add-apt-repository --yes --update ppa:ansible/ansible \n sudo apt install ansible -y \n sudo apt install git -y \n mkdir ansible/ \n cd ansible \n touch ansible.cfg \n cat > ansible.cfg <<EOF \n [defaults]\n inventory = /ansible/hosts \n EOF"

vm_nodes = [ 
  # {
  # instance_name = "ansible-vm-1"
  # image = "ubuntu-os-cloud/ubuntu-2204-lts"
  # vm_subnetwork = "private-ip-vm-subnet"
  # zone = "europe-west1-d"
  # vm_service_account = "pvt-vm-sa"
  # source_ranges = [ 
  #   "35.235.240.0/20" 
  #   ]
  # members = [ 
  #   "user:aben.george@searce.com"
  # ]
  # startup_script = " #! /bin/bash \n sudo apt update \n wget https://bootstrap.pypa.io/get-pip.py \n python3 ./get-pip.py \n python3 -m pip install -r requirements.txt \n python3 -m pip install yamllint \n sudo apt-get install software-properties-common \n sudo add-apt-repository --yes --update ppa:ansible/ansible \n sudo apt install ansible -y \n EOF"
  # }, 
  # {
  # instance_name = "ansible-vm-2"
  # image = "ubuntu-os-cloud/ubuntu-2204-lts"
  # zone = "europe-west1-b"
  # vm_subnetwork = "private-ip-vm-subnet"
  # vm_service_account = "pvt-vm-sa"
  # source_ranges = [ 
  #   "35.235.240.0/20",
  #   "10.0.1.0/24" 
  #   ]
  # members = [ 
  #   "user:aben.george@searce.com"
  # ]
  # startup_script = " #! /bin/bash \n sudo apt update \n wget https://bootstrap.pypa.io/get-pip.py \n python3 ./get-pip.py \n python3 -m pip install -r requirements.txt \n python3 -m pip install yamllint \n sudo apt-get install software-properties-common \n sudo add-apt-repository --yes --update ppa:ansible/ansible \n sudo apt install ansible -y \n EOF"
  # }, 
  # {
  # instance_name = "ansible-vm-3"
  # image = "ubuntu-os-cloud/ubuntu-2204-lts"
  # zone = "europe-west1-c"
  # vm_subnetwork = "private-ip-vm-subnet"
  # vm_service_account = "pvt-vm-sa"
  # source_ranges = [ 
  #   "35.235.240.0/20",
  #   "10.0.1.0/24"
  #   ]
  # members = [ 
  #   "user:aben.george@searce.com"
  # ]
  # startup_script = " #! /bin/bash \n sudo apt update \n wget https://bootstrap.pypa.io/get-pip.py \n python3 ./get-pip.py \n python3 -m pip install -r requirements.txt \n python3 -m pip install yamllint \n sudo apt-get install software-properties-common \n sudo add-apt-repository --yes --update ppa:ansible/ansible \n sudo apt install ansible -y \n EOF"
  # }, 
  {
  instance_name = "test-vm-1"
  image = "ubuntu-os-cloud/ubuntu-2204-lts"
  vm_subnetwork = "gke-subnet-pvt"
  zone = "europe-west1-d"
  vm_service_account = "pvt-vm-sa"
  enable_public_ip = true
  source_ranges = [ 
    "35.235.240.0/20" 
    ]
  members = [ 
    "user:aben.george@searce.com"
  ]
  startup_script = ""
  }, 
]

#######################
##  Service Account  ##
#######################
service_accounts = [ 
{
  account_id        = "polygon-gc-ba-sa"
  display_name      = "Polygon GKE Service Account"
  project_iam_roles = [ 
    "roles/binaryauthorization.policyAdmin",
    "roles/binaryauthorization.attestorsAdmin",
    "roles/artifactregistry.admin",
    "roles/container.admin",
    "roles/containeranalysis.notes.occurrences.viewer",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  ]
  project_services = "binaryauthorization.googleapis.com"
  default_iam_roles = [ "roles/containeranalysis.notes.occurrences.viewer" ]
},
]

############################
##  Binary Authorization  ##
############################
enable_binary_authorization = true
attestor-name = "polygon_attestor"
ba_key = "polygon-gke-key2"

#################
##  Cloud KMS  ##
#################
kms = [ 
  {
  new_ring = false
  keyring = "polygon-keyring"
  key                  = "polygon-gke-key2"
  kms_purpose          = "ASYMMETRIC_SIGN"
  key_rotation_period  = "169200s"
  prevent_destroy      = false
  key_algorithm        = "RSA_SIGN_PKCS1_4096_SHA512"#"GOOGLE_SYMMETRIC_ENCRYPTION"
  key_protection_level = "SOFTWARE"
  kms_labels           = {
    "env"              = "test"
  }
  encrypters_decrypters = "polygon-gc-ba-sa"
  },
]

#########################
##  Artifact Registry  ##
#########################
repo_format = "DOCKER"
artifact_repository_id = "test-repo"

########################
##  SSL Certificates  ##
########################
ssl_cert_name = "gateway-test-ssl"
cert_domains = [ "gateway.searce-aben.com" ]

##################
##  Kubernetes  ##
##################
manifest_files = [ 
  "global_ext_gateway.yaml",
  "applications/un.yaml",
  "applications/duo.yaml",
  "applications/tres.yaml",
  "applications/httproute.yaml",
  "path_redirects/httproute_entire_path_redirect.yaml" ]

#################
##  Cloud DNS  ##
#################
dns_name = "searce-aben.com"
record_set_name = "gateway"
dns_managed_zone = "gateway-testing-zone"

#######################
##   Cloud Storage   ##
#######################
gcs_key_name = "test-gcs-key"
storage_buckets = [ {
  name               = "test-kyc-source-docs"
  storage_class      = "STANDARD"
  versioning_enabled = false
  account_id         = "test-gc-cf-sa"
  object =[{
  object_name        = "id-cards.zip"
  object_source      = "source-code/id-cards.zip"
  }]
  temporary_hold = false
  lifecycle_rules = [ {
    action =  {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition = {
      age = 60
    }
  },
  {
    action =  {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
    condition = {
      age = 120
    }
  },
  ]
},
# {
#   name               = "test-kyc-source-code"
#   storage_class      = "STANDARD"
#   versioning_enabled = false
#   account_id         = "test-gc-cf-sa"
#   object = [{
#   object_name        = "document-processor.zip"
#   object_source      = "source-code/cloud_function/document-processor.zip"
#   }]
#   temporary_hold = false
#   lifecycle_rules = [ {
#     action =  {
#       type = "SetStorageClass"
#       storage_class = "NEARLINE"
#     }
#     condition = {
#       age = 60
#     }
#   },
#   {
#     action =  {
#       type = "SetStorageClass"
#       storage_class = "COLDLINE"
#     }
#     condition = {
#       age = 120
#     }
#   }, ]
# } ,
# {
#   name               = "test-app-engine-source-code"
#   storage_class      = "STANDARD"
#   versioning_enabled = false
#   account_id         = "test-gc-ae-sa"
#   object = [{
#   object_name        = "sqlalchemy.zip"
#   object_source      = "source-code/app_engine/sqlalchemy.zip"
#   }]
#   temporary_hold = false
#   lifecycle_rules = [ {
#     action =  {
#       type = "SetStorageClass"
#       storage_class = "NEARLINE"
#     }
#     condition = {
#       age = 60
#     }
#   },
#   {565
#     action =  {
#       type = "SetStorageClass"
#       storage_class = "COLDLINE"
#     }
#     condition = {
#       age = 120
#     }
#   }, ]
# },

]

gitlab_pat_api = "pat_api"
gitlab_api_token = "glpat-nvFSrWSPdBnf_BSz6EYz"
gitlab_pat_read = "pat_reap_api"
gitlab_read_api_token = "glpat-f4Pps8w5TzKyd7FrweXd"
webhook_secret =  "webhook_pat"
webhook_secret_value = ""
project_number = "695102146078"
connection_name = "projects/prj-test/locations/asia-south1/connections/test-gitlab"
host_uri = "https://gitlab.com"
gitlab_repo = "Aben_George-document-ai-in-gcp"
ssl_ca = ""
repo_name = "Document Ai In Gcp"
remote_uri = "https://gitlab.com/Aben_George/document-ai-in-gcp.git"   
gitlab_cloudbuild_name = "gitlab_cf_build"
gsr_cloudbuild_name = "gsr-cf-cloudbuild"
trigger_description = "Trigger to create Cloud Function"
tags = [
  "test",
  "test"
]
filename ="cloudbuild.yaml"
gitlab_trigger_config = {
  "gitlab" = {
    branch_regex = "master"
  }
  "gsr" = null
}
gsr_trigger_config = {
  "gsr" = {
    branch_regex = "master"
    project_id = "prj-test"
    repo_name = "github_abengeorge-searce_document-ai-in-gcp"
  }
  "gitlab" = null
}

dir =  "./Document-processing-function"
invert_regex = false


#######################
##   Cloud Function  ##
#######################
vpc_connector_egress_settings = "PRIVATE_RANGES_ONLY"
cf_service_accounts = [ 
  {
  account_id        = "test-gc-ea-sa"
  display_name      = "Test EventArc Service Account"
  project_services = "eventarc.googleapis.com"
  default_iam_roles = [ "roles/eventarc.serviceAgent" ]
},
 ]
source_docs = "test-kyc-source-docs"
cf_key_name = "test-cf-key"
topic_name                       = "docai-topic"
sub_name                         = "docai-sub"
function_name                    = "test-document-proccessor"
cf_runtime                          = "python311"
entry_point                      = "main"
min_instance_count               = 1
max_instance_count               = 2
available_memory                 = 4096
timeout_seconds                  = 60
max_instance_request_concurrency = 80
available_cpu                    = "4"
ingress_settings                 = "ALLOW_INTERNAL_ONLY"
all_traffic_on_latest_revision   = true
retry_policy                     = "RETRY_POLICY_RETRY"
cf_sa                            = "test-gc-cf-sa"
event_trigger = {
  event_type = "google.cloud.storage.object.v1.finalized"
}
# event_trigger                      = "google.storage.object.finalize"

###################
##  Document AI  ##
###################
docai_name = "document-processor"
processor_type = "FORM_PARSER_PROCESSOR"

#################################
##   CloudSQL for PostgreSQL   ##
#################################
sql_database               = "test-postgre"
sql_database_instance_name = "test-db"
connector_enforcement = "REQUIRED"
csql_key_name = "test-postgresql-key"
authorized_networks = {
  name = "test_auth"
  value = "0.0.0.0/0"
  expiration_time = "2024-11-15T16:19:00.094Z"
}
password_validation_policy =  {
  min_length = 16
  complexity = "COMPLEXITY_DEFAULT"
  disallow_username_substring = true
} 
sql_password               = "Test-test-123456"
sql_user                   = "test-user"
deletion_protection        = false
deletion_protection_enabled = false
postgres_root_password     = "Functionroot-123456"

######################
##  svpc connector  ##
######################
# connector_name = "postgres-svpc-test"
# connector_ip_cidr_range = "10.219.88.0/28"
# # svpc_subnet = "gc-test-private-subnet"
# min_throughput      = 200
# max_throughput      = 300

####################
##   App Engine   ##
####################
service_version = "py1234"
aef_service_accounts = [ 
  {
  account_id        = "test-gc-aef-sa"
  display_name      = "Test App Engine Flexi Service Account"
  project_services = "appengineflex.googleapis.com"
  default_iam_roles = [ "roles/cloudkms.cryptoKeyEncrypterDecrypter" ]
  },
  # {
  # account_id        = "test-gc-ae-sa"
  # display_name      = "Test App Engine Service Account"
  # project_services = "appengine.googleapis.com"
  # default_iam_roles = [ "roles/cloudkms.cryptoKeyEncrypterDecrypter" ]
  # }
 ]
app_service         = "default"
ae_runtime         = "python"
instance_class  = "F1"
# domain_name = "example.com"
# ssl_settings = {
#     certificate_id = "test1234"
#     ssl_management_type = "AUTOMATIC"
# }
source_range = "*"
action       = "ALLOW"
description  = "Firewall rule to allow all incoming traffic."
priority     = 1000
# Variables for Zip Module
zip = "test-app-engine-source-code"
# {
#   source_url  = "https://storage.googleapis.com/prj-test-8.appspot.com/www-react-postgres-main.zip"
#   files_count = null
# }

# Variables for Entrypoint block
# entrypoint = {
#   shell = "python main.py"
# }


max_concurrent_requests = 10
# max_idle_instances      = 10
# max_pending_latency     = "1s"
# min_idle_instances      = 3
# min_pending_latency     = "0.01s"
cpu_utilization = [ {
  target_utilization = 0.6
} ]
min_total_instances                 = 1
max_total_instances                 = 3
domain = "*"
path = "/*"
