<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_app_engine_application.appengine_app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_application) | resource |
| [google_app_engine_firewall_rule.firewall_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_firewall_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action"></a> [action](#input\_action) | (Required) The action to take if this rule matches. Possible values are UNSPECIFIED\_ACTION, ALLOW, and DENY. | `string` | `"ALLOW"` | no |
| <a name="input_auth_domain"></a> [auth\_domain](#input\_auth\_domain) | (Optional) The domain to authenticate users with when using App Engine's User API. | `string` | `null` | no |
| <a name="input_database_type"></a> [database\_type](#input\_database\_type) | (Optional) The type of the Cloud Firestore or Cloud Datastore database associated with this application. Can be `CLOUD_FIRESTORE` or `CLOUD_DATASTORE_COMPATIBILITY` for new instances. | `string` | `"CLOUD_DATASTORE_COMPATIBILITY"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) An optional string description of this rule. | `string` | `null` | no |
| <a name="input_feature_settings"></a> [feature\_settings](#input\_feature\_settings) | (Optional) A block of optional settings to configure specific App Engine features. | <pre>object({<br>    split_health_checks = bool<br>  })</pre> | `null` | no |
| <a name="input_iap"></a> [iap](#input\_iap) | (Optional) Settings for enabling Cloud Identity Aware Proxy. | <pre>object({<br>    oauth2_client_id     = string,<br>    oauth2_client_secret = string<br>  })</pre> | `null` | no |
| <a name="input_location_id"></a> [location\_id](#input\_location\_id) | (Required) The location to serve the app from. | `string` | `""` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | (Optional) A positive integer that defines the order of rule evaluation. Rules with the lowest priority are evaluated first. A default rule at priority Int32.MaxValue matches all IPv4 and IPv6 traffic when no previous rule matches. Only the action of this rule can be modified by the user. | `number` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) The project ID to create the application under. ~>NOTE: GCP only accepts project ID, not project number. If you are using number, you may get a `Permission denied` error. | `string` | `""` | no |
| <a name="input_serving_status"></a> [serving\_status](#input\_serving\_status) | (Optional) The serving status of the app. | `string` | `"SERVING"` | no |
| <a name="input_source_range"></a> [source\_range](#input\_source\_range) | Required) IP address or range, defined using CIDR notation, of requests that this rule applies to. | `string` | `"0.0.0.0/0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_id"></a> [app\_id](#output\_app\_id) | Identifier of the app, usually {PROJECT\_ID}. |
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | Unique name of the app, usually apps/{PROJECT\_ID}. |
| <a name="output_code_bucket"></a> [code\_bucket](#output\_code\_bucket) | The GCS bucket code is being stored in for this app. |
| <a name="output_default_bucket"></a> [default\_bucket](#output\_default\_bucket) | The GCS bucket content is being stored in for this app. |
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | The default hostname for this app. |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | An identifier for the resource with format apps/{{project}}/firewall/ingressRules/{{priority}} |
| <a name="output_gcr_domain"></a> [gcr\_domain](#output\_gcr\_domain) | The GCR domain used for storing managed Docker images for this app. |
| <a name="output_id"></a> [id](#output\_id) | An identifier for the resource with format {{project}}. |
| <a name="output_url_dispatch_rule"></a> [url\_dispatch\_rule](#output\_url\_dispatch\_rule) | A list of dispatch rule blocks. Each block has a domain, path, and service field. |
<!-- END_TF_DOCS -->