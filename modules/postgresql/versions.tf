terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# provider "google-beta" {
#   project = var.project_id
#   alias = "workaround"
# }
