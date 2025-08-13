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
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.private_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | `"Genesis"` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The vpc to deploy the ALB | `string` | `""` | no |
| <a name="input_white_list_ip"></a> [white\_list\_ip](#input\_white\_list\_ip) | The IP address to whitelist, allow to access the vpc through the SSH | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_sg_id"></a> [alb\_sg\_id](#output\_alb\_sg\_id) | The ID of the alb security group |
| <a name="output_private_sg_id"></a> [private\_sg\_id](#output\_private\_sg\_id) | The ID of the private security group |
| <a name="output_public_sg_id"></a> [public\_sg\_id](#output\_public\_sg\_id) | The ID of the public security group |