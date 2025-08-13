resource "aws_s3_object" "env_file" {
  bucket = var.secret_bucket
  key    = "${var.env}/${var.service_name}/.env"
  source = var.env_file_path
}

########################################
# ECS Policy and Role Definitions
########################################

resource "aws_iam_policy" "allow_get_secret" {
  name = "${var.project}-${var.env}-${var.service_name}-allow-get-secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:GetObject",
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::${var.secret_bucket}/${var.env}/${var.service_name}/*"
    }]
  })
}

locals {
  container_definitions = [
    for container in var.container_configs : {
      name   = container.name
      image  = container.image
      memory = container.memory
      cpu    = container.cpu
      portMappings = [{
        containerPort = container.port_mappings.container_port
        hostPort      = container.port_mappings.host_port
      }]
      command = length(container.command) > 0 ? container.command : null

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.lg.name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.service_name
          awslogs-create-group  = "true"
        }
      }

      environmentFiles = [
        {
          value = "arn:aws:s3:::${var.secret_bucket}/${var.env}/${var.service_name}/.env"
          type  = "s3"
        }
      ]
    }
  ]
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project}-${var.env}-${var.service_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project}-${var.env}-${var.service_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "allow_push_log" {
  name = "${var.project}-${var.env}-${var.service_name}-allow-push-log"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_policy" "allow_get_token_ecr_repo" {
  name = "${var.project}-${var.env}-${var.service_name}-allow-get-token-log"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "ecr:GetAuthorizationToken"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_policy" "allow_get_bucket_location" {
  name = "${var.project}-${var.env}-${var.service_name}-allow-get-bucket-location"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:GetBucketLocation",
        "s3:ListBucket"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

locals {
  all_policy_arns = tolist(concat([
    aws_iam_policy.allow_get_secret.arn,
    aws_iam_policy.allow_push_log.arn,
    aws_iam_policy.allow_get_token_ecr_repo.arn,
    aws_iam_policy.allow_get_bucket_location.arn
  ], var.additional_task_policy_arns))
}

resource "aws_iam_role_policy_attachment" "attack_additional_policy_for_task" {
  policy_arn = aws_iam_policy.allow_push_log.arn
  role       = aws_iam_role.ecs_task_role.name

  depends_on = [aws_iam_role.ecs_task_role, aws_iam_policy.allow_push_log]
}

resource "aws_iam_role_policy_attachment" "attack_additional_policy_for_execution" {
  count = length(local.all_policy_arns)

  policy_arn = element(local.all_policy_arns, count.index)
  role       = aws_iam_role.ecs_execution_role.name

  depends_on = [aws_iam_role.ecs_execution_role, aws_iam_policy.allow_get_secret, aws_iam_policy.allow_push_log]
}

########################################
# ECS log definitions
########################################

resource "aws_cloudwatch_log_group" "lg" {
  name              = "${var.project}-${var.env}-${var.service_name}-logs"
  retention_in_days = 7
}

########################################
# ECS Task and service definitions
########################################

resource "aws_ecs_task_definition" "task" {
  family       = "${var.service_name}-${var.env}-td"
  network_mode = "awsvpc"

  container_definitions = jsonencode(local.container_definitions)

  requires_compatibilities = ["FARGATE"]

  cpu    = var.task_cpu
  memory = var.task_memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
}

resource "aws_alb_target_group" "tg" {
  count = length(var.redirect_host_header) > 0 ? 1 : 0

  name        = "${var.project}-${var.env}-${var.service_name}-tg"
  port        = var.target_group_port
  protocol    = "HTTP"
  vpc_id      = var.vpc
  target_type = "ip"
  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  load_balancing_algorithm_type     = "round_robin"
  load_balancing_cross_zone_enabled = "true"
}

resource "aws_ecs_service" "svc" {
  name            = "${var.project}-${var.env}-${var.service_name}-svc"
  cluster         = var.ecs_cluster
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.min_task_numbers

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  dynamic "load_balancer" {
    for_each = length(var.redirect_host_header) > 0 ? [1] : []
    content {
      target_group_arn = aws_alb_target_group.tg[0].arn
      container_name   = var.container_configs[0].name
      container_port   = var.service_port
    }
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }

  depends_on = [aws_alb_target_group.tg]

  lifecycle {
    ignore_changes = [task_definition]
  }
}

########################################
# ECS Routing Rules
########################################

resource "aws_alb_listener_rule" "listener-rule" {
  count = length(var.redirect_host_header) > 0 ? 1 : 0

  listener_arn = var.alb_listener
  priority     = var.alb_listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg[0].arn

    redirect {
      host        = "#{host}"
      path        = "#{path}"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = var.redirect_host_header
    }
  }

  depends_on = [aws_alb_target_group.tg]
}

########################################
# ECS Scaling Policies
########################################

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_task_numbers
  min_capacity       = var.min_task_numbers
  resource_id        = "service/${var.ecs_cluster}/${aws_ecs_service.svc.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name               = "${var.project}-${var.env}-${var.service_name}-CPUTargetTrackingScaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.average_cpu_to_scale

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  name               = "${var.project}-${var.env}-${var.service_name}-MemoryTargetTrackingScaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.average_ram_to_scale

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}