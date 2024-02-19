resource "google_app_engine_application" "appengine_app" {
  project        = var.project
  location_id    = var.location_id
  auth_domain    = var.auth_domain
  database_type  = var.database_type
  serving_status = var.serving_status
  dynamic "feature_settings" {
    for_each = var.feature_settings[*]
    content {
      split_health_checks = feature_settings.value.split_health_checks
    }
  }
  dynamic "iap" {
    for_each = var.iap[*]
    content {
      oauth2_client_id     = iap.value.oauth2_client_id
      oauth2_client_secret = iap.value.oauth2_client_secret
    }
  }
}

# resource "google_app_engine_domain_mapping" "domain_mapping" {
#   domain_name = var.domain_name
#   project = var.project
#   dynamic "ssl_settings" {
#     for_each = var.ssl_settings[*]
#     content {
#       certificate_id                 = ssl_settings.value.certificate_id
#       ssl_management_type            = ssl_settings.value.ssl_management_type
#     }
#   }
#   override_strategy = var.override_strategy
# }

resource "google_app_engine_firewall_rule" "firewall_rule" {
  source_range = var.source_range
  project = var.project
  action       = var.action
  description  = var.description
  priority     = var.priority

  depends_on = [ 
    google_app_engine_application.appengine_app 
  ]
}

