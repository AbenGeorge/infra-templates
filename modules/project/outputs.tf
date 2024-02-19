# output "project_parent" {
#   description = "The parent of the project"
#   value       = google_project.project.folder_id != null ? google_project.project.folder_id : google_project.project.org_id
# }

# output "project_name" {
#   description = "The display name of the project"
#   value       = google_project.project.name
# }

# output "project_id" {
#   description = "The id of the project"
#   value       = google_project.project.project_id
# }

# output "project_number" {
#   description = "The number of the project"
#   value       = google_project.project.number
# }

# output "project_billing_account" {
#   description = "The billing account linked to the project"
#   value       = google_project.project.billing_account
# }


# output "project_labels" {
#   description = "The labels of the project"
#   value       = google_project.project.labels
# }

output "project_services" {
  description = "The Google project services"
  value       = [for service in google_project_service.service : service.service]
}

# output "role" {
#   value = length(google_project_iam_binding.iam_policy_binding) > 0 ? [
#     for iam_binding in google_project_iam_binding.iam_policy_binding : {
#       role    = iam_binding.role
#       members = iam_binding.members
#     }
#   ] : null
#   description = "Role assigned to users to a specific project"
# }
