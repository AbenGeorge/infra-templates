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
| [google_document_ai_processor.processor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/document_ai_processor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the Document AI processor | `string` | n/a | yes |
| <a name="input_processor_type"></a> [processor\_type](#input\_processor\_type) | The type of processor | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID of the document AI | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->