resource "google_secret_manager_secret" "secret_manager_secrets" {
  project   = var.project_id
  secret_id = "${var.project}_${var.environment}_${var.secret_id}"
  labels    = var.labels
  replication {
    user_managed {
      replicas {
        location = var.location
        customer_managed_encryption {
          kms_key_name = var.kms_key_name
        }
      }
    }
  }
}

resource "google_secret_manager_secret_version" "secret_version_basic" {
  secret      = google_secret_manager_secret.secret_manager_secrets.id
  secret_data = file(var.secret_data_file_path)
}
