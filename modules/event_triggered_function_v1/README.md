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
| [google_cloudfunctions2_function.function](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions2_function) | resource |
| [google_project_iam_binding.bucket_service_agent](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_pubsub_subscription.echo](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | resource |
| [google_pubsub_topic.alert-topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_all_traffic_on_latest_revision"></a> [all\_traffic\_on\_latest\_revision](#input\_all\_traffic\_on\_latest\_revision) | Whether all traffic should be routed to the latest revision of the Cloud Function | `bool` | `true` | no |
| <a name="input_available_cpu"></a> [available\_cpu](#input\_available\_cpu) | The available CPU of the Cloud Function | `string` | `"4"` | no |
| <a name="input_available_memory"></a> [available\_memory](#input\_available\_memory) | The available memory of the Cloud Function | `string` | `"4Gi"` | no |
| <a name="input_cf_service_account"></a> [cf\_service\_account](#input\_cf\_service\_account) | The sevice account used for Cloud Functions | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description of the Cloud Function | `string` | `"a new function"` | no |
| <a name="input_entry_point"></a> [entry\_point](#input\_entry\_point) | The entry point of the Cloud Function | `string` | `"helloPubSub"` | no |
| <a name="input_event_trigger"></a> [event\_trigger](#input\_event\_trigger) | A source that fires events in response to a condition in another service. | `map(string)` | `{}` | no |
| <a name="input_ingress_settings"></a> [ingress\_settings](#input\_ingress\_settings) | The ingress settings of the Cloud Function | `string` | `"ALLOW_INTERNAL_ONLY"` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | A Cloud KMS key that will be used to encrypt objects inserted into this bucket | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the Cloud Function | `string` | `"us-central1"` | no |
| <a name="input_max_instance_count"></a> [max\_instance\_count](#input\_max\_instance\_count) | The maximum instance count of the Cloud Function | `number` | `3` | no |
| <a name="input_max_instance_request_concurrency"></a> [max\_instance\_request\_concurrency](#input\_max\_instance\_request\_concurrency) | The maximum instance request concurrency of the Cloud Function | `number` | `80` | no |
| <a name="input_min_instance_count"></a> [min\_instance\_count](#input\_min\_instance\_count) | The minimum instance count of the Cloud Function | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Cloud Function | `string` | `"gcf-function"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID of the cloud Pub/Sub | `string` | n/a | yes |
| <a name="input_project_number"></a> [project\_number](#input\_project\_number) | The project number of the cloud Pub/Sub | `string` | n/a | yes |
| <a name="input_retry_policy"></a> [retry\_policy](#input\_retry\_policy) | The retry policy to be enabled in case of failed response | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime of the Cloud Function | `string` | `"nodejs16"` | no |
| <a name="input_storage_bucket_code"></a> [storage\_bucket\_code](#input\_storage\_bucket\_code) | The ID of the bucket ie source code | `string` | n/a | yes |
| <a name="input_storage_bucket_code_object"></a> [storage\_bucket\_code\_object](#input\_storage\_bucket\_code\_object) | The ID of the bucket object ie source code | `string` | n/a | yes |
| <a name="input_storage_bucket_docs"></a> [storage\_bucket\_docs](#input\_storage\_bucket\_docs) | The ID of the bucket ie source docs | `string` | n/a | yes |
| <a name="input_sub_name"></a> [sub\_name](#input\_sub\_name) | The name of the subscription in google pub/sub | `string` | n/a | yes |
| <a name="input_timeout_seconds"></a> [timeout\_seconds](#input\_timeout\_seconds) | The timeout in seconds of the Cloud Function | `number` | `60` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | The name of the topic in google pub/sub | `string` | n/a | yes |
| <a name="input_trigger_region"></a> [trigger\_region](#input\_trigger\_region) | The trigger region of the Cloud Function event | `string` | `"us-central1"` | no |
| <a name="input_vpc_connector"></a> [vpc\_connector](#input\_vpc\_connector) | The Serverless VPC Access connector that this cloud function can connect to | `string` | n/a | yes |
| <a name="input_vpc_connector_egress_settings"></a> [vpc\_connector\_egress\_settings](#input\_vpc\_connector\_egress\_settings) | Available egress settings. Possible values: [VPC\_CONNECTOR\_EGRESS\_SETTINGS\_UNSPECIFIED, PRIVATE\_RANGES\_ONLY, ALL\_TRAFFIC] | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_all_traffic_on_latest_revision"></a> [function\_all\_traffic\_on\_latest\_revision](#output\_function\_all\_traffic\_on\_latest\_revision) | Whether all traffic should be routed to the latest revision of the Cloud Function |
| <a name="output_function_available_cpu"></a> [function\_available\_cpu](#output\_function\_available\_cpu) | The available CPU of the Cloud Function |
| <a name="output_function_available_memory"></a> [function\_available\_memory](#output\_function\_available\_memory) | The available memory of the Cloud Function |
| <a name="output_function_description"></a> [function\_description](#output\_function\_description) | The description of the Cloud Function |
| <a name="output_function_entry_point"></a> [function\_entry\_point](#output\_function\_entry\_point) | The entry point of the Cloud Function |
| <a name="output_function_event_type"></a> [function\_event\_type](#output\_function\_event\_type) | The event type of the Cloud Function trigger |
| <a name="output_function_ingress_settings"></a> [function\_ingress\_settings](#output\_function\_ingress\_settings) | The ingress settings of the Cloud Function |
| <a name="output_function_location"></a> [function\_location](#output\_function\_location) | The location of the Cloud Function |
| <a name="output_function_max_instance_count"></a> [function\_max\_instance\_count](#output\_function\_max\_instance\_count) | The maximum instance count of the Cloud Function |
| <a name="output_function_max_instance_request_concurrency"></a> [function\_max\_instance\_request\_concurrency](#output\_function\_max\_instance\_request\_concurrency) | The maximum instance request concurrency of the Cloud Function |
| <a name="output_function_min_instance_count"></a> [function\_min\_instance\_count](#output\_function\_min\_instance\_count) | The minimum instance count of the Cloud Function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the Cloud Function |
| <a name="output_function_pubsub_topic"></a> [function\_pubsub\_topic](#output\_function\_pubsub\_topic) | The Pub/Sub topic associated with the Cloud Function |
| <a name="output_function_runtime"></a> [function\_runtime](#output\_function\_runtime) | The runtime of the Cloud Function |
| <a name="output_function_timeout_seconds"></a> [function\_timeout\_seconds](#output\_function\_timeout\_seconds) | The timeout in seconds of the Cloud Function |
| <a name="output_function_trigger_region"></a> [function\_trigger\_region](#output\_function\_trigger\_region) | The trigger region of the Cloud Function event |
<!-- END_TF_DOCS -->