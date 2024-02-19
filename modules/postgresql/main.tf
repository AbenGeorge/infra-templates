##############################
## Cloud SQL for PostgreSQL ##
##############################
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

############################
## Private Service Access ##
############################
resource "google_compute_global_address" "ip_allocation" {

  project = var.project_id
  network = var.network_id

  name          = var.ip_allocation_name
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 24
}

resource "google_service_networking_connection" "private_connection" {
  network = var.network_id
  service = "servicenetworking.googleapis.com"
  # provider = google-beta.workaround

  reserved_peering_ranges = [
    google_compute_global_address.ip_allocation.name
  ]

  depends_on = [ 
    google_compute_global_address.ip_allocation
   ]
}

# resource "google_project_service_identity" "cloudsql_sa" {
#   provider = google-beta
#   project = var.project_id
#   service = "sqladmin.googleapis.com"
# }

# resource "google_kms_crypto_key_iam_binding" "encrypters_decrypters" {
#   role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
#   crypto_key_id = var.kms_key_name
#   members       = [
#     "serviceAccount:${google_project_service_identity.cloudsql_sa.email}"
#   ]
#   depends_on = [ 
#     google_project_service_identity.cloudsql_sa
#    ]
# }

resource "google_sql_database_instance" "postgresql" {
  project = var.project_id

  depends_on = [ 
    google_service_networking_connection.private_connection,
   ]
   
  name   = var.sql_database_instance_name
  region = var.region

  database_version    = var.database_version
  deletion_protection = var.deletion_protection
  encryption_key_name = var.kms_key_name

  root_password = var.postgres_root_password == "" ?  random_password.password.result : base64decode(var.postgres_root_password)

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    disk_size         = var.disk_size
    disk_autoresize   = var.disk_autoresize
    disk_type         = var.disk_type
    deletion_protection_enabled = var.deletion_protection_enabled
    connector_enforcement = var.connector_enforcement


    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
      enable_private_path_for_google_cloud_services = true
      authorized_networks {
        name = var.authorized_networks.name
        value = var.authorized_networks.value
        expiration_time = var.authorized_networks.expiration_time
      }
    }

    backup_configuration {
      binary_log_enabled             = false
      enabled                        = true
      point_in_time_recovery_enabled = true
      location                       = var.region
      start_time                     = ""


      backup_retention_settings {
        retained_backups = var.backup_retention_count
      }
    }

    

    insights_config {
      query_insights_enabled = true
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = "stable"
    }

    password_validation_policy {
      min_length = var.password_validation_policy.min_length
      complexity = var.password_validation_policy.complexity
      disallow_username_substring = var.password_validation_policy.disallow_username_substring
      enable_password_policy = true
    }
  }
}

resource "google_sql_database" "sql_database" {
  project = var.project_id

  name     = var.sql_database
  instance = google_sql_database_instance.postgresql.name

  depends_on = [ 
    google_sql_database_instance.postgresql
   ]
}

resource "google_sql_user" "sql_user" {
  project = var.project_id

  name     = var.sql_user
  instance = google_sql_database_instance.postgresql.name
  # host     = google_sql_database_instance.postgresql.private_ip_address
  password = var.sql_password == "" ?  random_password.password.result : base64decode(var.sql_password)

  depends_on = [ 
    google_sql_database.sql_database,
    google_sql_database_instance.postgresql
   ]
}
