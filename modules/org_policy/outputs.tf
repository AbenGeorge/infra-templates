output "org_policy_constraint_parent" {
  description = "The parent of organization policy constraint"
  value       = google_org_policy_policy.org_policy.parent
}

output "org_policy_constraint_name" {
  description = "The name of organization policy constraint"
  value       = google_org_policy_policy.org_policy.name
}

output "org_policy_constraint_id" {
  description = "The id of organization policy constraint"
  value       = google_org_policy_policy.org_policy.id
}
