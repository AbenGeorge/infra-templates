output "secret_id" {
  description = "The Secret ID which is being created"
  value       = google_secret_manager_secret.secret_manager_secrets.id
}