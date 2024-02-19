output "project_id" {
  value       = google_storage_bucket.storage_bucket.project
  description = "The project ID of the GCS bucket."
}

output "name" {
  value       = google_storage_bucket.storage_bucket.name
  description = "The name of the GCS bucket created."
}

output "url" {
  value       = google_storage_bucket.storage_bucket.url
  description = "The URL of the GCS bucket."
}

output "location" {
  value       = google_storage_bucket.storage_bucket.location
  description = "The location of the GCS bucket."
}

output "storage_class" {
  value       = google_storage_bucket.storage_bucket.storage_class
  description = "The storage class of the GCS bucket."
}

output "versioning_enabled" {
  value       = google_storage_bucket.storage_bucket.versioning[0].enabled
  description = "The status of versioning enabled for the GCS bucket."
}

output "object_id" {
  # value = length(google_storage_bucket_object.object) > 0 ? google_storage_bucket_object.object[*].name : null
  value = length(google_storage_bucket_object.object) > 0 ? [for object in google_storage_bucket_object.object : object.name ] : null
  description = "The ID of the object located in the storage bucket"
}