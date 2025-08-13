variable "project" {
  description = "The project name"
  type        = string
  default     = "Genesis"
}

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
  default     = ["us-west-1b", "us-west-1c"]
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
