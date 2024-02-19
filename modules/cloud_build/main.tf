
# resource "random_integer" "random_id" {
#   min = 1690554047600
#   max = 1690999999999
#   keepers = {
#     gitlab_api_token = var.gitlab_api_token
#   }
# }
# resource "google_secret_manager_secret" "api-pat-secret" {
#     project = var.project_id
#     secret_id = "cloudbuild-gitlab-${random_integer.random_id.keepers.gitlab_api_token}-api-access-token"

#     replication {
#         automatic = true
#      }
#  }

#  resource "google_secret_manager_secret_version" "api-pat-secret-version" {
#      secret = google_secret_manager_secret.api-pat-secret.id
#      secret_data = var.gitlab_api_token
#      depends_on = [  
#       google_secret_manager_secret.api-pat-secret
#      ]
#  }

#  resource "google_secret_manager_secret" "read-pat-secret" {
#      project = var.project_id
#      secret_id = "cloudbuild-gitlab-${random_integer.random_id.keepers.gitlab_api_token}-read-api-access-token"

#      replication {
#          automatic = true
#      }
# }

# resource "google_secret_manager_secret_version" "read-pat-secret-version" {
#     secret = google_secret_manager_secret.read-pat-secret.id
#     secret_data = var.gitlab_read_api_token

#     depends_on = [  
#       google_secret_manager_secret.read-pat-secret
#     ]
# }

# resource "google_secret_manager_secret" "webhook-secret-secret" {
#     project = var.project_id
#     secret_id = "cloudbuild-gitlab-${random_integer.random_id.keepers.gitlab_api_token}-webhook-secret"

#     replication {
#         automatic = true
#     }
# }

# resource "google_secret_manager_secret_version" "webhook-secret-secret-version" {
#     secret = google_secret_manager_secret.webhook-secret-secret.id
#     secret_data = var.webhook_secret_value
#     depends_on = [  
#       google_secret_manager_secret.webhook-secret-secret
#     ]
# }

# # data "google_iam_policy" "serviceagent-secretAccessor" {
# #     binding {
# #         role = "roles/secretmanager.secretAccessor"
# #         members = ["serviceAccount:service-PROJECT_NUMBER@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
# #     }
# # }

# resource "google_secret_manager_secret_iam_member" "binding-pak" {
#   project = var.project_id
#   secret_id = google_secret_manager_secret.api-pat-secret.secret_id
#   member = format("serviceAccount:service-%s@gcp-sa-cloudbuild.iam.gserviceaccount.com", var.project_number)
#   role = "roles/secretmanager.secretAccessor"

#   depends_on = [  
#     google_secret_manager_secret_version.api-pat-secret-version
#   ]
# }

# resource "google_secret_manager_secret_iam_member" "binding-whs" {
#   project = var.project_id
#   secret_id = google_secret_manager_secret.webhook-secret-secret.secret_id
#   member = format("serviceAccount:service-%s@gcp-sa-cloudbuild.iam.gserviceaccount.com", var.project_number)
#   role = "roles/secretmanager.secretAccessor"
#   depends_on = [  
#     google_secret_manager_secret_version.webhook-secret-secret-version
#   ]
# }

# resource "google_secret_manager_secret_iam_member" "binding-rpak" {
#   project = var.project_id
#   secret_id = google_secret_manager_secret.read-pat-secret.secret_id
#   member = format("serviceAccount:service-%s@gcp-sa-cloudbuild.iam.gserviceaccount.com", var.project_number)
#   role = "roles/secretmanager.secretAccessor"

#   depends_on = [  
#     google_secret_manager_secret_version.read-pat-secret-version
#   ]
# }

# # resource "google_secret_manager_secret_iam_policy" "policy-pak" {
# #   project = google_secret_manager_secret.private-key-secret.project
# #   secret_id = google_secret_manager_secret.private-key-secret.secret_id
# #   policy_data = data.google_iam_policy.serviceagent-secretAccessor.policy_data
# # }

# # resource "google_secret_manager_secret_iam_policy" "policy-rpak" {
# #   project = google_secret_manager_secret.webhook-secret-secret.project
# #   secret_id = google_secret_manager_secret.webhook-secret-secret.secret_id
# #   policy_data = data.google_iam_policy.serviceagent-secretAccessor.policy_data
# # }

# # resource "google_secret_manager_secret_iam_policy" "policy-whs" {
# #   project = google_secret_manager_secret.webhook-secret-secret.project
# #   secret_id = google_secret_manager_secret.webhook-secret-secret.secret_id
# #   policy_data = data.google_iam_policy.serviceagent-secretAccessor.policy_data
# # }

# // create the connection and add the repository resource
# # resource "google_cloudbuildv2_connection" "repo-connection" {
# #   count = var.gitlab_enabled ? 1 : 0
# #   provider = google-beta
# #   project = var.project_id
# #   location = var.region
# #   name = var.connection_name

# #   gitlab_config {
# #       authorizer_credential {
# #           user_token_secret_version = google_secret_manager_secret_version.api-pat-secret-version.id
# #       }
# #       read_authorizer_credential {
# #             user_token_secret_version = google_secret_manager_secret_version.read-pat-secret-version.id
# #       }
# #       host_uri = var.host_uri
# #       ssl_ca  = var.ssl_ca
# #       webhook_secret_secret_version = google_secret_manager_secret_version.webhook-secret-secret-version.id
# #   }

# #   depends_on = [
# #       google_secret_manager_secret_iam_member.binding-pak,
# #       google_secret_manager_secret_iam_member.binding-rpak,
# #       google_secret_manager_secret_iam_member.binding-whs
# #   ]
# # }

# resource "google_cloudbuildv2_repository" "my-repository" {
#   count = var.gitlab_enabled ? 1 : 0
#   provider = google-beta
#   project = var.project_id
#   name = var.repo_name
#   location = var.region
#   parent_connection = var.connection_name#google_cloudbuildv2_connection.repo-connection.name
#   remote_uri = var.remote_uri

#   depends_on = [ 
#     google_secret_manager_secret_version.api-pat-secret-version,
#     google_secret_manager_secret_version.read-pat-secret-version,
#     google_secret_manager_secret_version.webhook-secret-secret-version
#   ]
# }

# resource "google_cloudbuild_trigger" "repo-trigger" {
#   name = var.cloudbuild_name
#   location = var.region
#   repository_event_config {
#     repository = google_cloudbuildv2_repository.repo-connection.id
#     push {
#       branch = var.branch
#     }
#   }

#   filename = "cloudbuild.yaml"
# }

resource "google_cloudbuild_trigger" "trigger" {
  project         = var.project_id
  provider = google-beta
  name            = var.cloudbuild_name
  description     = var.trigger_description
  build {
    source {
      repo_source {
        project_id = var.project_id
        repo_name = var.trigger_config["gsr"].repo_name
        dir = var.dir
        invert_regex = var.invert_regex
        branch_name = var.trigger_config["gsr"].repo_name
      }
    }
    options {
      logging = "CLOUD_LOGGING_ONLY"
    }
    step {
      name = "gcr.io/cloud-builders/git"
      args = [
        "clone", 
        "https://github.com/AbenGeorge-Searce/document-ai-in-gcp.git"
      ]
      volumes {
        name = "cloudfunction"
        path = "/persistant_volume"
      }
    }
    step {
      name = "gcr.io/cloud-builders/gcloud"
      args = [
        "functions",
        "deploy", 
        "icici-extractor",
        "--gen2", 
        "--runtime=python310", 
        "--project=prj-icici-26",
        "--region=asia-south1", 
        "--source=.", 
        "--entry-point=main",
        "--memory=4Gi",
        "--serve-all-traffic-latest-revision", 
        "--trigger-location=asia-south1",
        # "--trigger-event=google.storage.object.finalize", 
        # "--trigger-resource=icici-kyc-source-docs-a11deef31d", 
        "--trigger-bucket=icici-kyc-source-docs-a11deef31d", 
        "--trigger-service-account=icici-gc-gcs-sa@prj-icici-26.iam.gserviceaccount.com",
        "--vpc-connector=postgres-svpc-icici",
        "--service-account=icici-gc-cf-sa@prj-icici-26.iam.gserviceaccount.com", 
        "--trigger-location=asia-south1"
      ]
      allow_failure = true
      volumes {
        name = "cloudfunction"
        path = "/persistant_volume"
      }
    }
  }
  disabled        = var.disabled
  # service_account = "projects/${var.project_id}/serviceAccounts/icici-gc-cf-sa@prj-icici-26.iam.gserviceaccount.com"
  tags            = var.tags
  # substitutions   = var.substitutions
  # ignored_files   = var.ignored_files
  # included_files  = var.included_files
  # filename        = var.filename
  location        = var.region
  
  # dynamic "repository_event_config" {
  #   for_each = {for k,v in var.trigger_config : k => v if k == "gitlab" && v != null }
  #   content {
  #     repository = var.gitlab_enabled ? google_cloudbuildv2_repository.repo-connection.id : var.gitlab
  #     push {
  #       branch = coalesce(trigger_template.value.branch_regex, "unspecified") != "unspecified" ? trigger_template.value.branch_regex : null
  #     }
  #   }
  # }

  # Google Source Repository trigger
  dynamic "trigger_template" {
    for_each = { for k, v in var.trigger_config : k => v if k == "gsr" && v != null }
    content {
      project_id   = trigger_template.value.project_id
      repo_name    = trigger_template.value.repo_name
      dir          = var.dir
      invert_regex = var.invert_regex
      branch_name  = coalesce(trigger_template.value.branch_regex, "unspecified") != "unspecified" ? trigger_template.value.branch_regex : null
    }
  }

  # depends_on = [  
  #   google_cloudbuildv2_repository.my-repository
  # ]
}