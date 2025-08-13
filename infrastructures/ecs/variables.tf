variable "project" {
  description = "The project name"
  type        = string
  default     = "<Project-name>"
}

variable "aws_profile" {
  description = "The profile name that you have configured in the file .aws/credentials"
  type        = string
  default     = "<Project-name>"
}

variable "aws_region" {
  description = "The AWS Region in which you want to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "white_list_ip" {
  description = "The IP address to whitelist, allow to access the vpc through the SSH"
  type        = list(string)
  default     = ["123.24.142.251/32"]
  nullable    = true
}


#########################################
##========[ VPC configuration ]========##
#########################################
variable "create_vpc" {
  description = "Create a VPC or not"
  type        = bool
  default     = true
}

variable "create_nat" {
  description = "Create a NAT Gateway or not"
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_az" {
  description = "The Availability Zone for the VPC"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "vpc_number_public_subnets" {
  description = "The total number of public subnets"
  type        = number
  default     = 2
}

variable "vpc_number_private_subnets" {
  description = "The total number of private subnets"
  type        = number
  default     = 2
}

variable "vpc_nat_gateway_eip" {
  description = "The EIP for the NAT Gateway"
  type        = string
  default     = ""
  nullable    = true
}

#########################################
##========[ ALB configuration ]========##
#########################################
variable "create_alb" {
  description = "Create a ALB or not"
  type        = bool
  default     = true
}

variable "enable_https" {
  description = "Set to true to create a HTTPS listener"
  type        = bool
  default     = true
}

variable "enable_http" {
  description = "Set to true to create a HTTP listener"
  type        = bool
  default     = true
}

variable "wildcard_domain" {
  description = "The wildcard domain for the ALB"
  type        = string
  default     = "*.example.com"
}

variable "dns_host_zone" {
  description = "The Route53 zone id"
  type        = string
  default     = "Z0348938167NKF2HPEFQL"
}


###########################################
##========[ EC2 utility service ]========##
###########################################
variable "utility_instance_ami" {
  description = "The AMI ID"
  type        = string
  default     = "ami-0075013580f6322a1" # amzn2-ami-ecs-kernel-5.10-hvm-2.0.20240613-x86_64-ebs
}
