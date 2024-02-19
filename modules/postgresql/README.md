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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.ip_allocation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_service_networking_connection.private_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_sql_database.sql_database](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database_instance.postgresql](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_user.sql_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | Network ip authorized to access SQL instance | <pre>object({<br>    name = string<br>    value = string<br>    expiration_time = string<br>  })</pre> | n/a | yes |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | The availability type for the Cloud SQL instance | `string` | `"REGIONAL"` | no |
| <a name="input_backup_retention_count"></a> [backup\_retention\_count](#input\_backup\_retention\_count) | The number of backups to retain in Cloud SQL backup configuration. | `number` | `8` | no |
| <a name="input_backup_start_time"></a> [backup\_start\_time](#input\_backup\_start\_time) | HH:MM format time indicating when backup configuration starts. | `string` | `"16:40"` | no |
| <a name="input_connector_enforcement"></a> [connector\_enforcement](#input\_connector\_enforcement) | Specifies if connections must use Cloud SQL connectors | `string` | n/a | yes |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | Database version to use | `string` | `"POSTGRES_14"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Protection against deleting SQL instance | `bool` | `false` | no |
| <a name="input_disk_autoresize"></a> [disk\_autoresize](#input\_disk\_autoresize) | Configuration to increase storage size | `bool` | `true` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The disk size for the Cloud SQL instance | `number` | `10` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | The disk type for the Cloud SQL instance | `string` | `"PD_SSD"` | no |
| <a name="input_ip_allocation_name"></a> [ip\_allocation\_name](#input\_ip\_allocation\_name) | The name for the global IP address range | `string` | n/a | yes |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | A Cloud KMS key that will be used to encrypt objects inserted into this bucket | `string` | n/a | yes |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | Day of week (1-7), starting on Monday | `number` | `1` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | Hour of day (0-23), ignored if day not set | `number` | `17` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | The ID of the Network where VM is being created | `string` | n/a | yes |
| <a name="input_password_validation_policy"></a> [password\_validation\_policy](#input\_password\_validation\_policy) | Config for password validation policy | <pre>object({<br>    min_length = number<br>    complexity = string<br>    disallow_username_substring = bool<br>  })</pre> | n/a | yes |
| <a name="input_postgres_root_password"></a> [postgres\_root\_password](#input\_postgres\_root\_password) | The password of `postgres` user in the Cloud SQL Instance | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The Google Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The location of the project resources being created | `string` | n/a | yes |
| <a name="input_sql_database"></a> [sql\_database](#input\_sql\_database) | The SQL Database | `string` | n/a | yes |
| <a name="input_sql_database_instance_name"></a> [sql\_database\_instance\_name](#input\_sql\_database\_instance\_name) | The Name of the Cloud SQL Instance | `string` | n/a | yes |
| <a name="input_sql_password"></a> [sql\_password](#input\_sql\_password) | The SQL Database Password | `string` | `""` | no |
| <a name="input_sql_user"></a> [sql\_user](#input\_sql\_user) | The SQL Database User | `string` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | The tier for Cloud SQL instance | `string` | `"db-custom-2-8192"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | The connection name of the instance to be used in connection strings. |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | The private IPv4 address assigned for the master instance |
| <a name="output_name"></a> [name](#output\_name) | The name for cloud SQL instance |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | The root password |
<!-- END_TF_DOCS -->