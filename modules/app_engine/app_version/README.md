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
| [google_app_engine_application_url_dispatch_rules.dispatch_rules](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_application_url_dispatch_rules) | resource |
| [google_app_engine_flexible_app_version.appengine_flexible_automatic_scaling](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_flexible_app_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_config"></a> [api\_config](#input\_api\_config) | (Optional) Serving configuration for Google Cloud Endpoints. | <pre>list(object({<br>    auth_fail_action = string,<br>    login            = string,<br>    script           = string,<br>    security_level   = string,<br>    url              = string<br>  }))</pre> | `null` | no |
| <a name="input_api_version"></a> [api\_version](#input\_api\_version) | (Optional; Default: 1)The version of the API in the given runtime environment that is used by your app. The field is deprecated for newer App Engine runtimes. | `number` | `1` | no |
| <a name="input_beta_settings"></a> [beta\_settings](#input\_beta\_settings) | (Optional) Metadata settings that are supplied to this version to enable beta runtime features. | `map(any)` | `null` | no |
| <a name="input_cloud_build_options"></a> [cloud\_build\_options](#input\_cloud\_build\_options) | (Optional) Options for the build operations performed as a part of the version deployment. Only applicable when creating a version using source code directly. | <pre>list(object({<br>    app_yaml_path       = string<br>    cloud_build_timeout = string<br>  }))</pre> | `null` | no |
| <a name="input_container"></a> [container](#input\_container) | (Optional) The Docker image for the container that runs the version. | <pre>list(object({<br>    image = string<br>  }))</pre> | `null` | no |
| <a name="input_cool_down_period"></a> [cool\_down\_period](#input\_cool\_down\_period) | Optional) The time period that the Autoscaler should wait before it starts collecting information from a new instance. This prevents the autoscaler from collecting information when the instance is initializing, during which the collected usage would not be reliable. | `string` | `"120s"` | no |
| <a name="input_cpu_utilization"></a> [cpu\_utilization](#input\_cpu\_utilization) | (Required) Target scaling by CPU usage. | <pre>list(object({<br>    target_utilization        = number<br>    aggregation_window_length = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_default_expiration"></a> [default\_expiration](#input\_default\_expiration) | (Optional) Duration that static files should be cached by web proxies and browsers. Only applicable if the corresponding StaticFilesHandler does not specify its own expiration time. | `string` | `null` | no |
| <a name="input_delete_service_on_destroy"></a> [delete\_service\_on\_destroy](#input\_delete\_service\_on\_destroy) | (Optional; Default: False)If set to true, the service will be deleted if it is the last version. | `bool` | `false` | no |
| <a name="input_disk_utilization"></a> [disk\_utilization](#input\_disk\_utilization) | (Optional) Target scaling by disk usage. | <pre>list(object({<br>    target_read_bytes_per_second  = number<br>    target_read_ops_per_second    = number<br>    target_write_bytes_per_second = number<br>    target_write_ops_per_second   = number<br>  }))</pre> | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | (Optional) Domain name to match against. | `string` | `null` | no |
| <a name="input_endpoints_api_service"></a> [endpoints\_api\_service](#input\_endpoints\_api\_service) | (Optional) Code and application artifacts that make up this version. | <pre>list(object({<br>    name                   = string<br>    config_id              = string<br>    rollout_strategy       = string<br>    disable_trace_sampling = bool<br>  }))</pre> | `null` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | (Optional) The entrypoint for the application. | <pre>object({<br>    shell = string<br>  })</pre> | `null` | no |
| <a name="input_env_variables"></a> [env\_variables](#input\_env\_variables) | (Optional) Environment variables to be passed to the App Engine service. | `map(any)` | `null` | no |
| <a name="input_files"></a> [files](#input\_files) | (Optional) Manifest of the files stored in Google Cloud Storage that are included as part of this version. | <pre>list(object({<br>    name       = string,<br>    sha1_sum   = string,<br>    source_url = string<br>  }))</pre> | `null` | no |
| <a name="input_handlers"></a> [handlers](#input\_handlers) | (Optional) An ordered list of URL-matching patterns that should be applied to incoming requests. The first matching URL handles the request and other request handlers are not attempted. | <pre>list(object({<br>    url_regex                   = string,<br>    security_level              = string,<br>    login                       = string,<br>    auth_fail_action            = string,<br>    redirect_http_response_code = string,<br>    script = object({<br>      script_path = string<br>    })<br>    static_files = object({<br>      path                  = string,<br>      upload_path_regex     = string,<br>      http_headers          = map(string),<br>      mime_type             = string,<br>      expiration            = string,<br>      require_matching_file = bool,<br>      application_readable  = bool<br>    })<br>  }))</pre> | `null` | no |
| <a name="input_inbound_services"></a> [inbound\_services](#input\_inbound\_services) | (Optional) A list of the types of messages that this application is able to receive. | `list(string)` | `null` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | (Optional; Default: F1) Instance class that is used to run this version. Valid values are AutomaticScaling: F1, F2, F4, F4\_1G BasicScaling or ManualScaling: B1, B2, B4, B4\_1G, B8 Defaults to F1 for AutomaticScaling and B2 for ManualScaling and BasicScaling. If no scaling is specified, AutomaticScaling is chosen. | `string` | `"F1"` | no |
| <a name="input_liveness_check_interval"></a> [liveness\_check\_interval](#input\_liveness\_check\_interval) | (Optional; Default `30s`) Interval between health checks. | `string` | `"30s"` | no |
| <a name="input_liveness_failure_threshold"></a> [liveness\_failure\_threshold](#input\_liveness\_failure\_threshold) | (Optional; Default 4) Number of consecutive failed checks required before removing traffic. | `number` | `4` | no |
| <a name="input_liveness_host"></a> [liveness\_host](#input\_liveness\_host) | (Optional) Host header to send when performing a HTTP Readiness check. | `string` | `null` | no |
| <a name="input_liveness_initial_delay"></a> [liveness\_initial\_delay](#input\_liveness\_initial\_delay) | (Optional; Default `300s`) A maximum time limit on application initialization, measured from moment the application successfully replies to a healthcheck until it is ready to serve traffic. | `string` | `"300s"` | no |
| <a name="input_liveness_path"></a> [liveness\_path](#input\_liveness\_path) | (Required; Default `/liveness`) The request path. | `string` | `"/liveness"` | no |
| <a name="input_liveness_success_threshold"></a> [liveness\_success\_threshold](#input\_liveness\_success\_threshold) | (Optional; Default 2) Number of consecutive successful checks required before receiving traffic. | `number` | `2` | no |
| <a name="input_liveness_timeout"></a> [liveness\_timeout](#input\_liveness\_timeout) | (Optional; Default `4s`) Time before the check is considered failed. | `string` | `"4s"` | no |
| <a name="input_max_concurrent_requests"></a> [max\_concurrent\_requests](#input\_max\_concurrent\_requests) | (Optional) Number of concurrent requests an automatic scaling instance can accept before the scheduler spawns a new instance. | `number` | `null` | no |
| <a name="input_max_total_instances"></a> [max\_total\_instances](#input\_max\_total\_instances) | (Optional; Default 20) Maximum number of instances that should be started to handle requests for this version. | `number` | `20` | no |
| <a name="input_min_total_instances"></a> [min\_total\_instances](#input\_min\_total\_instances) | (Optional; Default 2) Minimum number of running instances that should be maintained for this version. | `number` | `2` | no |
| <a name="input_network"></a> [network](#input\_network) | (Optional) Extra network settings to be defined for the App Engine service. | <pre>object({<br>    forwarded_ports  = list(string),<br>    instance_tag     = string,<br>    name             = string,<br>    subnetwork       = string,<br>    session_affinity = bool<br>  })</pre> | `null` | no |
| <a name="input_network_utilization"></a> [network\_utilization](#input\_network\_utilization) | (Optional) Target scaling by network usage. | <pre>list(object({<br>    target_received_bytes_per_second   = number<br>    target_received_packets_per_second = number<br>    target_sent_bytes_per_second       = number<br>    target_sent_packets_per_second     = number<br>  }))</pre> | `null` | no |
| <a name="input_nobuild_files_regex"></a> [nobuild\_files\_regex](#input\_nobuild\_files\_regex) | (Optional) Files that match this pattern will not be built into this version. Only applicable for Go runtimes. | `string` | `null` | no |
| <a name="input_noop_on_destroy"></a> [noop\_on\_destroy](#input\_noop\_on\_destroy) | (Optional; Default: True)If set to true, the application version will not be deleted upon running Terraform destroy. | `bool` | `true` | no |
| <a name="input_path"></a> [path](#input\_path) | (Required; Default: /*) Pathname within the host. Must start with a `/`. A single `*` can be included at the end of the path. | `string` | `"/*"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID of the App Engine | `string` | n/a | yes |
| <a name="input_readiness_app_start_timeout"></a> [readiness\_app\_start\_timeout](#input\_readiness\_app\_start\_timeout) | (Optional; Default `300s`) A maximum time limit on application initialization, measured from moment the application successfully replies to a healthcheck until it is ready to serve traffic. | `string` | `"300s"` | no |
| <a name="input_readiness_check_interval"></a> [readiness\_check\_interval](#input\_readiness\_check\_interval) | (Optional; Default `5s`) Interval between health checks. | `string` | `"5s"` | no |
| <a name="input_readiness_failure_threshold"></a> [readiness\_failure\_threshold](#input\_readiness\_failure\_threshold) | (Optional; Default 2) Number of consecutive failed checks required before removing traffic. | `number` | `2` | no |
| <a name="input_readiness_host"></a> [readiness\_host](#input\_readiness\_host) | (Optional) Host header to send when performing a HTTP Readiness check. | `string` | `null` | no |
| <a name="input_readiness_path"></a> [readiness\_path](#input\_readiness\_path) | (Required; Default `/readiness`) The request path. | `string` | `"/readiness"` | no |
| <a name="input_readiness_success_threshold"></a> [readiness\_success\_threshold](#input\_readiness\_success\_threshold) | (Optional; Default 2) Number of consecutive successful checks required before receiving traffic. | `number` | `2` | no |
| <a name="input_readiness_timeout"></a> [readiness\_timeout](#input\_readiness\_timeout) | (Optional; Default `4s`) Time before the check is considered failed. | `string` | `"4s"` | no |
| <a name="input_request_utilization"></a> [request\_utilization](#input\_request\_utilization) | (Optional) Target scaling by request utilization. | <pre>list(object({<br>    target_request_count_per_second = number<br>    target_concurrent_requests      = string<br>  }))</pre> | `null` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | (Optional) Machine resources for a version. | <pre>object({<br>    cpu       = number,<br>    disk_gb   = number,<br>    memory_gb = number,<br>    volumes = list(object({<br>      name        = string,<br>      volume_type = string,<br>      size_gb     = number<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | (Required; Default: python) The runtime that will be used by App Engine. Supported runtimes are: python27, python37, python38, java8, java11, php55, php73, php74, ruby25, go111, go112, go113, go114, nodejs10, nodejs12. | `string` | `"python"` | no |
| <a name="input_runtime_channel"></a> [runtime\_channel](#input\_runtime\_channel) | (Optional) The channel of the runtime to use. Only available for some runtimes. | `string` | `null` | no |
| <a name="input_runtime_main_executable_path"></a> [runtime\_main\_executable\_path](#input\_runtime\_main\_executable\_path) | (Optional) The path or name of the app's main executable. | `string` | `null` | no |
| <a name="input_service"></a> [service](#input\_service) | (Required; Default: default) Name of the App Engine Service | `string` | `"default"` | no |
| <a name="input_service_version"></a> [service\_version](#input\_service\_version) | (Optional) Name of the App Engine version of the Service that will be deployed. | `string` | `null` | no |
| <a name="input_serving_status"></a> [serving\_status](#input\_serving\_status) | (Optional) Current serving status of this version. Only the versions with a SERVING status create instances and can be billed. | `string` | `null` | no |
| <a name="input_zip"></a> [zip](#input\_zip) | (Optional) Zip File Structure. | <pre>object({<br>    source_url  = string,<br>    files_count = number<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dispatch_id"></a> [dispatch\_id](#output\_dispatch\_id) | An identifier for the resource with format {{project}} |
| <a name="output_id"></a> [id](#output\_id) | An identifier for the resource with format apps/{{project}}/services/{{service}}/versions/{{version\_id}} |
| <a name="output_name"></a> [name](#output\_name) | Full path to the Version resource in the API. Example, `v1`. |
<!-- END_TF_DOCS -->