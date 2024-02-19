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

resource "google_project_iam_binding" "bucket_service_agent" {
  members = [ 
    format("serviceAccount:service-%s@gs-project-accounts.iam.gserviceaccount.com",var.project_number),
    "serviceAccount:icici-gc-gcs-sa@${var.project_id}.iam.gserviceaccount.com" 
  ]
  role = "roles/pubsub.publisher"
  project = var.project_id

  depends_on = [ 
    google_pubsub_subscription.echo
   ]

}

resource "google_cloudfunctions2_function" "function" {
  name        = var.name
  location    = var.location
  description = var.description
  project = var.project_id
  

  build_config {
    runtime      = var.runtime
    entry_point  = var.entry_point
    environment_variables = {
      BUILD_CONFIG_TEST = "build_test"
    }
    # source {
    #   repo_source {
    #     branch_name = var.source_branch_name
    #     repo_name = var.source_repo_name
    #     dir = "./Document-processing-function"
    #   }
    # }
  }

  service_config {
    max_instance_count                 = var.max_instance_count
    min_instance_count                 = var.min_instance_count
    vpc_connector = var.vpc_connector
    vpc_connector_egress_settings = var.vpc_connector_egress_settings
    available_memory                   = var.available_memory
    timeout_seconds                    = var.timeout_seconds
    max_instance_request_concurrency   = var.max_instance_request_concurrency
    available_cpu                      = var.available_cpu
    environment_variables = {
      SERVICE_CONFIG_TEST = "config_test"
    }
    ingress_settings                   = var.ingress_settings
    all_traffic_on_latest_revision     = var.all_traffic_on_latest_revision
    service_account_email              = var.cf_service_account
  }

  dynamic "event_trigger" {
    for_each = var.event_trigger != null ? var.event_trigger : {}

    content {  
      trigger_region  = var.trigger_region
      event_type      = var.event_trigger["event_type"]
      # pubsub_topic    = google_pubsub_topic.alert-topic.id
      retry_policy    = var.retry_policy
      service_account_email = var.cf_service_account
      event_filters {
        attribute = "bucket"
        value = var.storage_bucket_docs
      }
    }
    
  }
  timeouts {
    create = "5m"
    update = "5m"
  }
  depends_on = [ 
    google_pubsub_subscription.echo,
    google_project_iam_binding.bucket_service_agent,
    time_sleep.wait_40_seconds,
    module.default_sa
   ]
}

