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
| [google_storage_bucket.storage_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | resource |
| [google_storage_bucket_object.object](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_encryption"></a> [encryption](#input\_encryption) | A Cloud KMS key that will be used to encrypt objects inserted into this bucket | <pre>object({<br>    default_kms_key_name = string<br>  })</pre> | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run | `bool` | `true` | no |
| <a name="input_google_storage_sa"></a> [google\_storage\_sa](#input\_google\_storage\_sa) | The service account used to access storage bucket | `string` | n/a | yes |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | The bucket's Lifecycle Rules configuration. | <pre>list(object({<br>    # Object with keys:<br>    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.<br>    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.<br>    action = any<br><br>    # Object with keys:<br>    # - age - (Optional) Minimum age of an object in days to satisfy this condition.<br>    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.<br>    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".<br>    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.<br>    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.<br>    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition<br>    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.<br>    condition = any<br>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The storage bucket location | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The storage bucket name | `string` | n/a | yes |
| <a name="input_object"></a> [object](#input\_object) | The config of the object present in the bucket | <pre>list(object({<br>    object_name = string<br>    object_source = string<br>  }))</pre> | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID in which bucket should be created | `string` | n/a | yes |
| <a name="input_public_access_prevention"></a> [public\_access\_prevention](#input\_public\_access\_prevention) | Enables uniform bucket-level access on a bucket | `string` | `"enforced"` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Class of storage for the bucket | `string` | `"STANDARD"` | no |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | Enables uniform bucket-level access on a bucket. | `bool` | `true` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Enable or disable object versioning for the bucket. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_location"></a> [location](#output\_location) | The location of the GCS bucket. |
| <a name="output_name"></a> [name](#output\_name) | The name of the GCS bucket created. |
| <a name="output_object_id"></a> [object\_id](#output\_object\_id) | The ID of the object located in the storage bucket |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The project ID of the GCS bucket. |
| <a name="output_storage_class"></a> [storage\_class](#output\_storage\_class) | The storage class of the GCS bucket. |
| <a name="output_url"></a> [url](#output\_url) | The URL of the GCS bucket. |
| <a name="output_versioning_enabled"></a> [versioning\_enabled](#output\_versioning\_enabled) | The status of versioning enabled for the GCS bucket. |
<!-- END_TF_DOCS -->