resource "google_artifact_registry_repository" "my-repo" {
  location      = var.location
  repository_id = var.artifact_repository_id
  description   = "example docker repository"
  format        = var.repo_format
  labels        = var.env
  project       = var.project_id
}
