output "arn_alb" {
  value = (var.create_alb == true
  ? (length(aws_alb.alb) > 0 ? aws_alb.alb[0].arn : "") : "")
}
output "arn_tg" {
  value = try(aws_alb_target_group.default_tg[0].arn, "")
}

output "tg_name" {
  value = try(aws_alb_target_group.default_tg[0].name, "")
}

output "arn_http_listener" {
  value = (var.create_alb == true
  ? (length(aws_alb_listener.http_listener) > 0 ? aws_alb_listener.http_listener[0].arn : "") : "")
}

output "arn_https_listener" {
  value = (var.create_alb == true
  ? (length(aws_alb_listener.https_listener) > 0 ? aws_alb_listener.https_listener[0].arn : "") : "")
}

output "dns_alb" {
  value = (var.create_alb == true
  ? (length(aws_alb.alb) > 0 ? aws_alb.alb[0].dns_name : "") : "")
}