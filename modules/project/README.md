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
| [google_compute_shared_vpc_host_project.host](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_host_project) | resource |
| [google_compute_shared_vpc_service_project.service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_service_project) | resource |
| [google_monitoring_monitored_project.monitoring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_monitored_project) | resource |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_service.service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_network"></a> [auto\_create\_network](#input\_auto\_create\_network) | The default VPC network gets created if it set to "true". | `bool` | `false` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The billing account linked to the project. | `string` | n/a | yes |
| <a name="input_host_project_id"></a> [host\_project\_id](#input\_host\_project\_id) | The project id of the shared vpc host for service projects. | `string` | `""` | no |
| <a name="input_is_shared_vpc_host"></a> [is\_shared\_vpc\_host](#input\_is\_shared\_vpc\_host) | If true, the project could be configured as shared vpc host. | `bool` | `false` | no |
| <a name="input_monitoring_project_id"></a> [monitoring\_project\_id](#input\_monitoring\_project\_id) | The project id of the monitoring project for monitored projects. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The id of the project. | `string` | n/a | yes |
| <a name="input_project_labels"></a> [project\_labels](#input\_project\_labels) | The labels of the project. | `map(string)` | `{}` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. | `string` | `""` | no |
| <a name="input_project_parent"></a> [project\_parent](#input\_project\_parent) | The parent to the project. | `string` | n/a | yes |
| <a name="input_project_services"></a> [project\_services](#input\_project\_services) | The Google Project services | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_monitoring_project"></a> [monitoring\_project](#output\_monitoring\_project) | The project id of the monitoring project under the project is monitored. |
| <a name="output_project_billing_account"></a> [project\_billing\_account](#output\_project\_billing\_account) | The billing account linked to the project |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The id of the project |
| <a name="output_project_labels"></a> [project\_labels](#output\_project\_labels) | The labels of the project |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The display name of the project |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | The number of the project |
| <a name="output_project_parent"></a> [project\_parent](#output\_project\_parent) | The parent of the project |
| <a name="output_project_services"></a> [project\_services](#output\_project\_services) | The Google project services |
| <a name="output_shared_vpc_host_project"></a> [shared\_vpc\_host\_project](#output\_shared\_vpc\_host\_project) | The project id of the shared vpc host for service projects. |
<!-- END_TF_DOCS -->