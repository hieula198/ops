# output "vpc_id" {
#   description = "The ID of the VPC created by the vpc module."
#   value       = module.vpc.vpc_id
# }
#
# output "public_subnet_ids" {
#   description = "List of public subnet IDs created by the vpc module."
#   value       = module.vpc.public_subnet_ids
# }
#
# output "private_subnet_ids" {
#   description = "List of private subnet IDs created by the vpc module."
#   value       = module.vpc.private_subnet_ids
# }
#
# output "public_sg_id" {
#   description = "ID of the public security group."
#   value       = module.sg.public_sg_id
# }
#
# output "private_sg_id" {
#   description = "ID of the private security group."
#   value       = module.sg.private_sg_id
# }

output "secrets_bucket_name" {
  description = "Name of the S3 bucket for secrets."
  value       = module.secrets_bucket.bucket_name
}

output "ecr_frontend_pull_policy" {
  description = "ARN of the frontend ECR pull policy."
  value       = module.ecr.frontend_pull_policy
}

output "ecr_backend_pull_policy" {
  description = "ARN of the backend ECR pull policy."
  value       = module.ecr.backend_pull_policy
}

# output "alb_arn" {
#   description = "ARN of the Application Load Balancer."
#   value       = module.alb.arn_alb
# }
#
# output "alb_dns_name" {
#   description = "DNS name of the Application Load Balancer."
#   value       = module.alb.dns_alb
# }
#
# output "alb_https_listener_arn" {
#   description = "ARN of the HTTPS listener for the ALB."
#   value       = module.alb.arn_https_listener
# }
#
# output "ecs_cluster_id" {
#   description = "ID of the ECS cluster."
#   value       = module.ecs.ecs_cluster_arn
# }
#
# output "tunnel_instance_id" {
#   description = "ID of the tunnel EC2 instance."
#   value       = aws_instance.tunnel_instance.id
# }
#
# output "tunnel_instance_public_ip" {
#   description = "Public IP of the tunnel EC2 instance."
#   value       = aws_instance.tunnel_instance.public_ip
# }
#
# output "ice_id" {
#   description = "ID of the EC2 Instance Connect Endpoint."
#   value       = aws_ec2_instance_connect_endpoint.ice.id
# }
#
# output "cloudfront_distribution_id" {
#   description = "ID of the CloudFront distribution."
#   value       = module.cloudfront.cloudfront_distribution_id
# }
#
# output "cloudfront_domain_name" {
#   description = "Domain name of the CloudFront distribution."
#   value       = module.cloudfront.cloudfront_domain_name
# }
#
