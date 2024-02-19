# Overview

This module makes it easy to set up a new VPC Network in GCP by defining your network and subnet ranges in a concise syntax.

It supports creating:

- A Google Virtual Private Network (VPC)
- Subnets within the VPC
- Firewall rules
- NAT Gateways

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
| [google_compute_address.nat_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_firewall.firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.router_nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_nat_config"></a> [cloud\_nat\_config](#input\_cloud\_nat\_config) | The Cloud NAT Configuration for VPC Networks | <pre>list(object({<br>    cloud_nat_name                        = string<br>    cloud_nat_region                      = string<br>    cloud_nat_advertised_subnetworks_list = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | The firewall Configuration for VPC Networks | <pre>list(object({<br>    name          = string<br>    target_tags   = list(string)<br>    source_ranges = list(string)<br>    firewall_allow = optional(list(object({<br>      protocol = string<br>      ports    = list(string)<br>    })))<br>    firewall_deny = optional(list(object({<br>      protocol = string<br>      ports    = list(string)<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_network_create_auto_subnetworks"></a> [network\_create\_auto\_subnetworks](#input\_network\_create\_auto\_subnetworks) | If true, it creates auto mode subnetworks. | `bool` | `false` | no |
| <a name="input_network_delete_default_network_routes"></a> [network\_delete\_default\_network\_routes](#input\_network\_delete\_default\_network\_routes) | If true, it deletes default network routes including Internet Gateway. | `bool` | `false` | no |
| <a name="input_network_description"></a> [network\_description](#input\_network\_description) | The description for the VPC Network. | `string` | `""` | no |
| <a name="input_network_mtu"></a> [network\_mtu](#input\_network\_mtu) | The MTU value of the VPC Network | `number` | `1460` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name for the VPC Network. | `string` | n/a | yes |
| <a name="input_network_routing_mode"></a> [network\_routing\_mode](#input\_network\_routing\_mode) | The routing mode of the VPC Network. Allowed values, 'GLOBAL' or 'REGIONAL'. | `string` | `"GLOBAL"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The id of the project. | `string` | n/a | yes |
| <a name="input_subnetworks"></a> [subnetworks](#input\_subnetworks) | The list of VPC Subnetworks | <pre>list(object({<br>    subnetwork_name                  = string<br>    subnetwork_description           = optional(string)<br>    subnetwork_region                = string<br>    subnetwork_ip_cidr_range         = string<br>    subnetwork_private_google_access = optional(bool)<br>    subnetwork_secondary_ranges      = optional(map(string))<br>    subnetwork_log_config = optional(list(object({<br>      aggregation_interval = optional(string)<br>      flow_sampling        = optional(number)<br>      metadata             = optional(string)<br>    })))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_nat_config"></a> [cloud\_nat\_config](#output\_cloud\_nat\_config) | The Cloud NAT Config for the VPC Network |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | The id of the VPC network |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC network |
| <a name="output_network_routing_mode"></a> [network\_routing\_mode](#output\_network\_routing\_mode) | The routing mode of the VPC network |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The self link of the VPC network |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The project id of the VPC network |
| <a name="output_subnetworks"></a> [subnetworks](#output\_subnetworks) | The subnetworks of the VPC Network |
<!-- END_TF_DOCS -->