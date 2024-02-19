resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_service_account_iam_member" "sa_iam_binding" {
  count = var.role != null && var.role != "" ? 1 : 0
  service_account_id = google_service_account.sa.id
  role               = var.role
  member             = var.member

  depends_on = [ 
    google_service_account.sa
   ]
}

resource "google_project_iam_member" "project_iam_binding" {
  for_each = can(length(var.project_iam_roles) > 0) ? toset(var.project_iam_roles) : []

  project = var.project_id
  role    = each.value
  member = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [ 
    google_service_account.sa
   ]
}

resource "google_project_service_identity" "cloud_sa" {
  count = var.project_services != null && var.project_services != "" ? 1 : 0
  provider = google-beta
  project = var.project_id
  service = var.project_services 
}

resource "google_project_iam_member" "default_iam_binding" {
  for_each = can(length(var.default_iam_roles) > 0) ? toset(var.default_iam_roles) : []

  project = var.project_id
  role    = each.value
  member = "serviceAccount:${google_project_service_identity.cloud_sa[0].email}"

  depends_on = [ 
    google_project_service_identity.cloud_sa
   ]
}

