output "ecs_cluster_name" {
  value       = aws_ecs_cluster.cluster.name
  description = "The ECS cluster name"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.cluster.arn
  description = "The ARN of the ECS cluster"
}
