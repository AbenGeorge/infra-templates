output "email" {
  value = google_service_account.sa.email
  description = "The e-mail address of the service account"
}

output "default_email" {
  value = google_project_service_identity.cloud_sa == [] ? "" : google_project_service_identity.cloud_sa[0].email 
  description = "The email ID of the default service account"
}