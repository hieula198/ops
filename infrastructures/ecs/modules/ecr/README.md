## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.ecr_lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_policy.backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | `"Genesis"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_pull_policy"></a> [backend\_pull\_policy](#output\_backend\_pull\_policy) | n/a |
| <a name="output_backend_repo"></a> [backend\_repo](#output\_backend\_repo) | n/a |
| <a name="output_backend_repo_arn"></a> [backend\_repo\_arn](#output\_backend\_repo\_arn) | n/a |
| <a name="output_frontend_pull_policy"></a> [frontend\_pull\_policy](#output\_frontend\_pull\_policy) | n/a |
| <a name="output_frontend_repo"></a> [frontend\_repo](#output\_frontend\_repo) | n/a |
| <a name="output_frontend_repo_arn"></a> [frontend\_repo\_arn](#output\_frontend\_repo\_arn) | n/a |
| <a name="output_notification_pull_policy"></a> [notification\_pull\_policy](#output\_notification\_pull\_policy) | n/a |
| <a name="output_notification_repo"></a> [notification\_repo](#output\_notification\_repo) | n/a |
| <a name="output_notification_repo_arn"></a> [notification\_repo\_arn](#output\_notification\_repo\_arn) | n/a |