output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.vpc[0].arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc[0].id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.vpc[0].cidr_block, null)
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "public_subnet_cidr_blocks" {
  description = "The CIDR blocks of the public subnets"
  value       = aws_subnet.public_subnets[*].cidr_block
}

output "private_subnet_cidr_blocks" {
  description = "The CIDR blocks of the private subnets"
  value       = aws_subnet.private_subnets[*].cidr_block
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw[0].id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat[0].id
}

output "nat_gateway_allocation_id" {
  description = "The Allocation ID of the NAT Gateway"
  value       = aws_nat_gateway.nat[0].allocation_id

}

output "nat_gateway_eip" {
  description = "The public IP of the NAT Gateway"
  value       = aws_nat_gateway.nat[0].public_ip
}