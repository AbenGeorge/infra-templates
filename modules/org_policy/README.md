# Overview

This Terraform module makes it easier to manage organization policies for your Google Cloud environment, particularly when you want to have exclusion rules. This module will allow you to set a top-level org policy and then disable it on individual projects or folders easily.

The org policies defined at <https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints> can be easily managed via this module.

The resources/services/activations/deletions that this module will create/trigger are:

- Create boolean constraints
- Create list constraints
- Allow/Deny the resources for a particular constraint

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
| [google_organization_policy.org_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The id of the organization. | `string` | n/a | yes |
| <a name="input_policy_bool_value"></a> [policy\_bool\_value](#input\_policy\_bool\_value) | The value for boolean policy constraint of the organization. | `bool` | `false` | no |
| <a name="input_policy_constraint"></a> [policy\_constraint](#input\_policy\_constraint) | The policy constraint of the organization. | `string` | n/a | yes |
| <a name="input_policy_list_type"></a> [policy\_list\_type](#input\_policy\_list\_type) | The type of list policy constraint of the organization. | `string` | `"allow"` | no |
| <a name="input_policy_list_values"></a> [policy\_list\_values](#input\_policy\_list\_values) | The values for list policy constraint of the organization. | `list(string)` | `[]` | no |
| <a name="input_policy_type"></a> [policy\_type](#input\_policy\_type) | The policy constraint type for the organization. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_org_policy_constraint_id"></a> [org\_policy\_constraint\_id](#output\_org\_policy\_constraint\_id) | The id of organization policy constraint |
| <a name="output_org_policy_constraint_name"></a> [org\_policy\_constraint\_name](#output\_org\_policy\_constraint\_name) | The name of organization policy constraint |
| <a name="output_org_policy_constraint_parent"></a> [org\_policy\_constraint\_parent](#output\_org\_policy\_constraint\_parent) | The parent of organization policy constraint |
<!-- END_TF_DOCS -->