resource "random_password" "password" {
  length = 16

  special = false
  numeric = true
  upper   = true
  lower   = true
}

resource "google_secret_manager_secret" "secret" {
  project = var.project_id

  secret_id = upper("${var.project}-${var.env}-${var.cluster_name}-alloydb-secret")

  replication {
    user_managed {
      replicas {
        location = var.region
        customer_managed_encryption {
          kms_key_name = var.kms_key_id
        }
      }
    }
  }

}

resource "google_secret_manager_secret_version" "secret_version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = random_password.password.result
}

################
## Alloy DB ##
################

# AlloyDB Cluster resource
resource "google_alloydb_cluster" "alloydb" {
  project = var.project_id
  network = var.network

  cluster_id = "${var.project}${var.env}${var.cluster_name}"
  location   = var.region

  initial_user {
    user     = "${var.project}${var.env}${var.cluster_name}"
    password = random_password.password.result
  }

  automated_backup_policy {
    location      = var.region
    backup_window = var.automated_backup_policy.backup_window
    enabled       = true

    # Define the weekly backup schedule
    weekly_schedule {
      days_of_week = [ # Days of the week for backups
        "MONDAY",
        "TUESDAY",
        "WEDNESDAY",
        "THURSDAY",
        "FRIDAY",
        "SATURDAY",
        "SUNDAY"
      ]

      # Split and set start times
      start_times {
        hours   = split(":", var.automated_backup_policy.start_time)[0]
        minutes = split(":", var.automated_backup_policy.start_time)[1]
        seconds = split(":", var.automated_backup_policy.start_time)[2]
        nanos   = split(":", var.automated_backup_policy.start_time)[3]
      }
    }

    time_based_retention {
      retention_period = var.automated_backup_policy.retention_period
    }
  }

  depends_on = [google_secret_manager_secret_version.secret_version]

}

resource "google_alloydb_instance" "primary_instance" {
  cluster       = google_alloydb_cluster.alloydb.name
  instance_id   = "${var.project}${var.env}${var.cluster_name}"
  instance_type = "PRIMARY"
  machine_config {
    cpu_count = var.primary_instance_cpu_count
  }
}

resource "google_alloydb_instance" "read_pool_instance" {
  cluster       = google_alloydb_cluster.alloydb.name
  instance_id   = "${var.project}${var.env}${var.cluster_name}-readpool"
  instance_type = "READ_POOL"

  # Configuration for the read pool
  read_pool_config {
    node_count = var.read_pool_node_count
  }

  machine_config {
    cpu_count = var.read_pool_cpu_count
  }

  # Ensure read pool instances depend on primary instances
  depends_on = [
    google_alloydb_instance.primary_instance
  ]
}
