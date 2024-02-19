output "id" {
  description = "An identifier for the resource with format {{project}}."
  value       = google_app_engine_application.appengine_app.id
}

output "app_name" {
  description = "Unique name of the app, usually apps/{PROJECT_ID}."
  value       = google_app_engine_application.appengine_app.name
}

output "app_id" {
  description = "Identifier of the app, usually {PROJECT_ID}."
  value       = google_app_engine_application.appengine_app.app_id
}

output "url_dispatch_rule" {
  description = "A list of dispatch rule blocks. Each block has a domain, path, and service field."
  value       = google_app_engine_application.appengine_app.url_dispatch_rule
}

output "code_bucket" {
  description = "The GCS bucket code is being stored in for this app."
  value       = google_app_engine_application.appengine_app.code_bucket
}

output "default_hostname" {
  description = "The default hostname for this app."
  value       = google_app_engine_application.appengine_app.default_hostname
}

output "default_bucket" {
  description = "The GCS bucket content is being stored in for this app."
  value       = google_app_engine_application.appengine_app.default_bucket
}

output "gcr_domain" {
  description = "The GCR domain used for storing managed Docker images for this app."
  value       = google_app_engine_application.appengine_app.gcr_domain
}

# output "domain_id" {
#   description = "An identifier for the resource with format apps/{{project}}/domainMappings/{{domain_name}}"
#   value       = google_app_engine_domain_mapping.domain_mapping.id
# }

# output "domain_name" {
#   description = "Full path to the DomainMapping resource in the API. Example: apps/myapp/domainMapping/example.com"
#   value       = google_app_engine_domain_mapping.domain_mapping.name
# }

# output "resource_records" {
#   description = "The resource records required to configure this domain mapping. These records must be added to the domain's DNS configuration in order to serve the application via this domain mapping."
#   value       = google_app_engine_domain_mapping.domain_mapping.resource_records
# }

# output "resource_records_name" {
#   description = "(Optional) Relative name of the object affected by this record. Only applicable for CNAME records. Example: 'www'."
#   value       = google_app_engine_domain_mapping.domain_mapping.resource_records[0]
# }

# output "resource_records_rdata" {
#   description = "(Optional) Data for this record. Values vary by record type, as defined in RFC 1035 (section 5) and RFC 1034 (section 3.6.1)."
#   value       = google_app_engine_domain_mapping.domain_mapping.resource_records[1]
# }

# output "resource_records_type" {
#   description = "(Optional) Resource record type. Example: AAAA. Possible values are A, AAAA, and CNAME."
#   value       = google_app_engine_domain_mapping.domain_mapping.resource_records[2]
# }

output "firewall_id" {
  description = "An identifier for the resource with format apps/{{project}}/firewall/ingressRules/{{priority}}"
  value       = google_app_engine_firewall_rule.firewall_rule.id
}
