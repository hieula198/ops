locals {
  instance_policy_arns = concat(var.policy_arns, [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role", // Amazon ECS managed policy
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"                      // To ssh into instances without public IP
  ])
  instance_policy_arns_map = {
    for idx, arn in tolist(local.instance_policy_arns) : idx => arn
  }
  services = jsondecode(file("./data/services.json"))
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-ecs-cluster"
}

resource "aws_iam_role" "ecs_instance" {
  name = "${var.project}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_instance_for_ecs" {
  for_each = local.instance_policy_arns_map

  policy_arn = each.value
  role       = aws_iam_role.ecs_instance.name
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.project}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name
}

module "ecs_service" {
  for_each = { for service in local.services : "${service["service_name"]}_${service["env"]}" => service }

  source          = "./ecs-service"
  project         = var.project
  region          = var.region
  ecs_cluster     = aws_ecs_cluster.cluster.name
  vpc             = var.vpc
  subnets         = var.subnets
  security_groups = var.security_groups
  log_bucket      = var.log_bucket
  alb             = var.alb
  alb_listener    = var.alb_listener
  secret_bucket   = var.secret_bucket

  additional_task_policy_arns = var.policy_arns
  env                         = each.value["env"]
  service_name                = each.value["service_name"]
  average_cpu_to_scale        = each.value["average_cpu_to_scale"]
  average_ram_to_scale        = each.value["average_ram_to_scale"]
  container_configs           = each.value["container_configs"]
  health_check_path           = each.value["health_check_path"]
  max_task_numbers            = each.value["max_task_numbers"]
  min_task_numbers            = each.value["min_task_numbers"]
  redirect_host_header        = each.value["redirect_host_header"]
  service_port                = each.value["service_port"]
  target_group_port           = each.value["target_group_port"]
  env_file_path               = each.value["env_file_path"]
  alb_listener_rule_priority  = each.value["alb_listener_rule_priority"]
  task_cpu                    = each.value["task_cpu"]
  task_memory                 = each.value["task_memory"]
}

