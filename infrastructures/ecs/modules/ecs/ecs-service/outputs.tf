output "ecs_service_name" {
  value       = aws_ecs_service.svc.name
  description = "The ECS service name"
}

output "ecs_service_tg_arn" {
  value       = aws_alb_target_group.tg[*].arn
  description = "The ECS target group arn"
}

output "ecs_service_alb_listener_rule_arn" {
  value       = aws_alb_listener_rule.listener-rule[*].arn
  description = "The ECS ALB listener rule arn"
}