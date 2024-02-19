output "function_name" {
  description = "The name of the Cloud Function"
  value       = google_cloudfunctions2_function.function.name
}

output "function_location" {
  description = "The location of the Cloud Function"
  value       = google_cloudfunctions2_function.function.location
}

output "function_description" {
  description = "The description of the Cloud Function"
  value       = google_cloudfunctions2_function.function.description
}

# output "function_runtime" {
#   description = "The runtime of the Cloud Function"
#   value       = google_cloudfunctions2_function.function.build_config[0].runtime
# }

# output "function_entry_point" {
#   description = "The entry point of the Cloud Function"
#   value       = google_cloudfunctions2_function.function.build_config[0].entry_point
# }

output "function_max_instance_count" {
  description = "The maximum instance count of the Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].max_instance_count
}

output "function_min_instance_count" {
  description = "The minimum instance count of the Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].min_instance_count
}

output "function_available_memory" {
  description = "The available memory of the Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].available_memory
}

output "function_timeout_seconds" {
  description = "The timeout in seconds of the Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].timeout_seconds
}

output "function_max_instance_request_concurrency" {
  description = "The maximum instance request concurrency of the Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].max_instance_request_concurrency
}

output "function_available_cpu" {
  description = "The available CPU of the Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].available_cpu
}

output "function_ingress_settings" {
  description = "The ingress settings of the Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].ingress_settings
}

output "function_all_traffic_on_latest_revision" {
  description = "Whether all traffic should be routed to the latest revision of the Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].all_traffic_on_latest_revision
}

output "function_trigger_region" {
  description = "The trigger region of the Cloud Function event"
  value       = google_cloudfunctions2_function.function.event_trigger[0].trigger_region
}

output "function_event_type" {
  description = "The event type of the Cloud Function trigger"
  value       = google_cloudfunctions2_function.function.event_trigger[0].event_type
}

output "function_pubsub_topic" {
  description = "The Pub/Sub topic associated with the Cloud Function"
  value       = google_cloudfunctions2_function.function.event_trigger[0].pubsub_topic
}
