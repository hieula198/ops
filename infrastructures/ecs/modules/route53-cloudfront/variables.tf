variable "project" {
  description = "The project name"
  type        = string
  default     = "Genesis"
}

variable "wildcard_domain" {
  description = "The wildcard domain for the Cloudfront distribution"
  type        = string
  default     = "*.example.com"
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
  default     = ""
}

variable "dns_host_zone" {
  description = "The Route53 zone id"
  type        = string
  default     = "XXXXXXXXXXXXXXXXX"
}