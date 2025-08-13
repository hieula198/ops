## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_asg"></a> [asg](#module\_asg) | ../ec2-asg | n/a |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | ./ecs-service | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_capacity_provider.ecs_cp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.ecs_ccp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_iam_instance_profile.ecs_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ecs_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_instance_for_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb"></a> [alb](#input\_alb) | The ALB to deploy the service | `string` | `""` | no |
| <a name="input_alb_listener"></a> [alb\_listener](#input\_alb\_listener) | The ALB listener to deploy the service | `string` | `""` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | Key pair name for the instances in the ASG | `string` | `"genesis-key-pair"` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | The bucket for the logs | `string` | `""` | no |
| <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns) | The policy ARNS to attach to the ECS task role besides the default policy | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | `"Genesis"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region | `string` | `"us-west-1"` | no |
| <a name="input_secret_bucket"></a> [secret\_bucket](#input\_secret\_bucket) | The name of the secret bucket | `string` | `""` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | The security group to deploy the service | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnets to deploy the service | `list(string)` | `[]` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The vpc to deploy the service | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | The ECS cluster name |
