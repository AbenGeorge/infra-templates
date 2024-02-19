locals {
  #TODO: Replace it with Actual Terraform Service Account
  terraform_service_account = "aben-gke-terraform-infra-auto@ce-ps-3team.iam.gserviceaccount.com"
  #TODO: Replace it with Actual Terraform Bootstrap Project ID
  terraform_project_id            = "ce-ps-3team"
  terraform_access_token_lifetime = "3600s"
}

terraform {
  backend "local" {
    path = "tfstate_local/terraform.tfstate"
  }
}
  # backend "gcs" {
  #   #TODO: Replace it with Actual Terraform Remote State Bucket
  #   bucket = "gc-terraform-remote_state"
  #   #TODO: Replace it with Actual Terraform Prefix
  #   prefix = "landing-zone-infra"
  #   #TODO: Replace it with Actual Terraform Service Account
  #   impersonate_service_account = "aben-gke-terraform-infra-auto@ce-ps-3team.iam.gserviceaccount.com"
  # }
# }

provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

# provider "kubernetes" {
  
# }

data "google_service_account_access_token" "default" {
  provider               = google.impersonation
  target_service_account = local.terraform_service_account
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = local.terraform_access_token_lifetime
}

provider "google" {
  project         = local.terraform_project_id
  access_token    = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}

# data "google_client_config" "provider" {}

# data "google_container_cluster" "gke_cluster" {
#   project  = var.project_id
#   name     = var.gke_cluster_name
#   location = var.location
# }

provider "kubernetes" {
  host  = "https://${module.gke_standard_cluster.endpoint}"
  # "https://${data.google_container_cluster.gke_cluster.endpoint}"
  token = data.google_service_account_access_token.default.access_token
  cluster_ca_certificate = base64decode(
    module.gke_standard_cluster.cluster_ca_certificate,
  )
}

provider "kubectl" {
  host  = "https://${module.gke_standard_cluster.endpoint}"
  # "https://${data.google_container_cluster.gke_cluster.endpoint}"
  token = data.google_service_account_access_token.default.access_token
  cluster_ca_certificate = base64decode(
    module.gke_standard_cluster.cluster_ca_certificate,
  )
}