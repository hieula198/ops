variable "project" {
  description = "The project name"
  type        = string
  default     = "Genesis"
}

variable "vpc" {
  description = "The vpc to deploy the ALB"
  type        = string
  default     = ""
}

variable "white_list_ip" {
  description = "The IP address to whitelist, allow to access the vpc through the SSH"
  type        = list(string)
  default     = []
  nullable    = true
}