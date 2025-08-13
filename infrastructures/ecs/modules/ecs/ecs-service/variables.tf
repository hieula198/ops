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

variable "service_name" {
  description = "The service name"
  type        = string
  default     = "backendService"
}

variable "env" {
  description = "The environment"
  type        = string
  default     = "dev"
}

variable "ecs_cluster" {
  description = "The ECS cluster"
  type        = string
  default     = ""
  nullable    = true
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

variable "service_port" {
  description = "The service port"
  type        = number
  default     = 80
}

variable "alb_listener" {
  description = "The ALB listener to deploy the service"
  type        = string
  default     = ""
}

variable "alb_listener_rule_priority" {
  description = "The ALB listener to deploy the service"
  type        = number
  default     = 100
}


variable "additional_task_policy_arns" {
  description = "Additional task policies for task role and task execution role"
  type        = list(string)
}

variable "health_check_path" {
  description = "The health check path"
  type        = string
  default     = "/"
}

variable "max_task_numbers" {
  description = "The max number of tasks in service"
  type        = number
  default     = 5
}

variable "min_task_numbers" {
  description = "The min number of tasks in service"
  type        = number
  default     = 1
}

variable "container_configs" {
  description = "The container configuration"
  type = list(object({
    name   = string
    image  = string
    memory = number
    cpu    = number
    port_mappings = object({
      container_port = number
      host_port      = number
    })
    command = optional(list(string), [])
  }))
  default = []
}

variable "target_group_port" {
  description = "The target group port"
  type        = number
  default     = 80
}

variable "redirect_host_header" {
  description = "The redirect host header to the service, For example: api.example.com > backend service"
  type        = list(string)
  default     = ["api.example.com"]
}

variable "average_cpu_to_scale" {
  description = "The average CPU to scale"
  type        = number
  default     = 80
}

variable "average_ram_to_scale" {
  description = "The average RAM to scale"
  type        = number
  default     = 80
}

variable "secret_bucket" {
  description = "The of the secret bucket"
  type        = string
  default     = ""
}

variable "env_file_path" {
  description = "The path to the env file"
  type        = string
  default     = ""
}

variable "task_cpu" {
  description = "The CPU for the task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "The memory for the task"
  type        = number
  default     = 512
}