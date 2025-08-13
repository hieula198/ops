output "public_sg_id" {
  description = "The ID of the public security group"
  value       = aws_security_group.public_sg.id
}

output "private_sg_id" {
  description = "The ID of the private security group"
  value       = aws_security_group.private_sg.id
}

output "alb_sg_id" {
  description = "The ID of the alb security group"
  value       = aws_security_group.alb_sg.id
}