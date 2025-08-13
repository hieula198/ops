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
| [aws_acm_certificate.default_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.default_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_alb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.http_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.https_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.default_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Create a ALB or not | `bool` | `true` | no |
| <a name="input_create_target_group"></a> [create\_target\_group](#input\_create\_target\_group) | Set to true to create a Target Group | `bool` | `false` | no |
| <a name="input_default_domain"></a> [default\_domain](#input\_default\_domain) | The default domain for the ALB | `string` | `"*.gen.vmo.dev"` | no |
| <a name="input_dns_host_zone"></a> [dns\_host\_zone](#input\_dns\_host\_zone) | The Route53 zone id | `string` | `"Z0348938167NKF2HPEFQL"` | no |
| <a name="input_enable_http"></a> [enable\_http](#input\_enable\_http) | Set to true to create a HTTP listener | `bool` | `false` | no |
| <a name="input_enable_https"></a> [enable\_https](#input\_enable\_https) | Set to true to create a HTTPS listener | `bool` | `false` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | The path in which the ALB will send health checks | `string` | `"/"` | no |
| <a name="input_health_check_port"></a> [health\_check\_port](#input\_health\_check\_port) | The port to which the ALB will send health checks | `number` | `80` | no |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | `"Genesis"` | no |
| <a name="input_sgs"></a> [sgs](#input\_sgs) | Default security groups for the instances | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnets to deploy the ALB | `list(string)` | `[]` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The vpc to deploy the ALB | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn_alb"></a> [arn\_alb](#output\_arn\_alb) | n/a |
| <a name="output_arn_http_listener"></a> [arn\_http\_listener](#output\_arn\_http\_listener) | n/a |
| <a name="output_arn_https_listener"></a> [arn\_https\_listener](#output\_arn\_https\_listener) | n/a |
| <a name="output_arn_tg"></a> [arn\_tg](#output\_arn\_tg) | n/a |
| <a name="output_dns_alb"></a> [dns\_alb](#output\_dns\_alb) | n/a |
| <a name="output_tg_name"></a> [tg\_name](#output\_tg\_name) | n/a |
