resource "google_pubsub_topic" "alert-topic" {
  name = var.topic_name
  project = var.project_id
  kms_key_name = var.kms_key_name
}

resource "google_pubsub_subscription" "echo" {
  name = var.sub_name
  topic = google_pubsub_topic.alert-topic.name
  project = var.project_id

  depends_on = [ 
    google_pubsub_topic.alert-topic 
  ]
}

module "default_sa" {
  source = "../service_account"

  for_each = {
    for accounts in var.default_sa : accounts.account_id => accounts
  }

  project_id = var.project_id
  account_id = each.value.account_id
  display_name = each.value.display_name
  default_iam_roles = each.value.default_iam_roles
  project_services = each.value.project_services
}

resource "time_sleep" "wait_40_seconds" {
  create_duration = "40s"
  depends_on = [ 
    module.default_sa
   ]
}

# resource "google_project_service_identity" "cloud_sa" {
#   provider = google-beta
#   project = var.project_id
#   service = "eventarc.googleapis.com"
# }

# resource "google_project_iam_binding" "project_iam_binding" {
#   project = var.project_id
#   role    = "roles/eventarc.serviceAgent"
#   members = ["serviceAccount:${google_project_service_identity.cloud_sa.email}"]

#   depends_on = [ 
#     google_project_service_identity.cloud_sa
#    ]
# }

resource "google_project_iam_member" "bucket_service_agent" {
  member = format("serviceAccount:service-%s@gs-project-accounts.iam.gserviceaccount.com",var.project_number)
  
  role = "roles/pubsub.publisher"
  project = var.project_id

  depends_on = [ 
    google_pubsub_subscription.echo
   ]

}

resource "google_cloudfunctions_function" "function" {
  name        = var.name
  description = var.description
  project = var.project_id
  # kms_key_name = var.kms_key_name
  

  available_memory_mb = var.available_memory
  runtime = var.runtime
  entry_point = var.entry_point
  vpc_connector = var.vpc_connector
  vpc_connector_egress_settings = var.vpc_connector_egress_settings
  max_instances = var.max_instance_count
  min_instances = var.min_instance_count
  timeout = var.timeout_seconds
  ingress_settings = var.ingress_settings
  region = var.location

  service_account_email = var.cf_service_account
  source_repository {
    url = var.source_repo_name
  }
  event_trigger {
    event_type = var.event_trigger
    resource = var.storage_bucket_docs
    failure_policy {
      retry = var.retry_policy
    }
  }     
  
  timeouts {
    create = "5m"
    update = "5m"
  }
  depends_on = [ 
    google_pubsub_subscription.echo,
    google_project_iam_member.bucket_service_agent,
    time_sleep.wait_40_seconds,
    module.default_sa
   ]
}

