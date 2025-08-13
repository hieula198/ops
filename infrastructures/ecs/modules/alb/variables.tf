variable "project" {
  description = "The project name"
  type        = string
  default     = "Genesis"
}

variable "create_alb" {
  description = "Create a ALB or not"
  type        = bool
  default     = true
}

variable "enable_https" {
  description = "Set to true to create a HTTPS listener"
  type        = bool
  default     = false
}

variable "enable_http" {
  description = "Set to true to create a HTTP listener"
  type        = bool
  default     = false
}

variable "vpc" {
  description = "The vpc to deploy the ALB"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "The subnets to deploy the ALB"
  type        = list(string)
  default     = []
}

variable "create_target_group" {
  description = "Set to true to create a Target Group"
  type        = bool
  default     = false
}


variable "health_check_path" {
  description = "The path in which the ALB will send health checks"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "The port to which the ALB will send health checks"
  type        = number
  default     = 80
}

variable "sgs" {
  description = "Default security groups for the instances"
  type        = list(string)
  default     = []
}

variable "wildcard_domain" {
  description = "The wildcard domain for the ALB"
  type        = string
  default     = "*.example.com"
}

variable "dns_host_zone" {
  description = "The Route53 zone id"
  type        = string
  default     = "XXXXXXXXXXXXXXXXX"
}