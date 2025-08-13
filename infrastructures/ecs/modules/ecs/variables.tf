variable "project" {
  description = "The project name"
  type        = string
  default     = "Genesis"
}

variable "region" {
  description = "The region"
  type        = string
  default     = "us-west-1"
}

variable "vpc" {
  description = "The vpc to deploy the service"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "The subnets to deploy the service"
  type        = list(string)
  default     = []
}

variable "security_groups" {
  description = "The security group to deploy the service"
  type        = list(string)
  default     = []
}

variable "log_bucket" {
  description = "The bucket for the logs"
  type        = string
  default     = ""
}

variable "alb" {
  description = "The ALB to deploy the service"
  type        = string
  default     = ""
}

variable "alb_listener" {
  description = "The ALB listener to deploy the service"
  type        = string
  default     = ""
}

variable "key_pair_name" {
  description = "Key pair name for the instances in the ASG"
  type        = string
  default     = "genesis-key-pair"
}

variable "policy_arns" {
  description = "The policy ARNS to attach to the ECS task role besides the default policy"
  type        = list(string)
  default     = []
}

variable "secret_bucket" {
  description = "The name of the secret bucket"
  type        = string
  default     = ""
}