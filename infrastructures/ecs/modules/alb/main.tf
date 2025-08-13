resource "aws_acm_certificate" "default_domain" {
  domain_name       = var.wildcard_domain
  validation_method = "DNS"

  tags = {
    Name = "${var.project}-default-certificate-for-ALB"
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.default_domain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  zone_id = var.dns_host_zone
  ttl     = 60
}

resource "aws_acm_certificate_validation" "default_domain" {
  certificate_arn         = aws_acm_certificate.default_domain.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]

  depends_on = [aws_route53_record.certificate_validation, aws_acm_certificate.default_domain]
}

resource "aws_alb" "alb" {
  count              = var.create_alb == true ? 1 : 0
  name               = "${var.project}-alb"
  subnets            = toset(var.subnets)
  load_balancer_type = "application"
  internal           = false
  enable_http2       = true
  idle_timeout       = 30
  security_groups    = var.sgs
}

resource "aws_alb_target_group" "default_tg" {
  count                = var.create_target_group == true ? 1 : 0
  name                 = "${var.project}-alb-default-tg"
  protocol             = "HTTP"
  vpc_id               = var.vpc
  target_type          = "instance"
  port                 = 80
  deregistration_delay = 5

  health_check {
    enabled             = true
    interval            = 15
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "https_listener" {
  count             = var.create_alb == true && var.enable_https == true && var.create_target_group ? 1 : 0
  load_balancer_arn = aws_alb.alb[0].arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    target_group_arn = aws_alb_target_group.default_tg[0].arn
    type             = "forward"
  }

  lifecycle {
    ignore_changes = [default_action]
  }

  certificate_arn = "arn:aws:acm:us-east-1:354024168685:certificate/d440cd34-1ac3-4d5b-a03f-68a9e50b3417"

  depends_on = [aws_alb.alb, aws_alb_target_group.default_tg]
}

resource "aws_alb_listener" "http_listener" {
  count             = var.create_alb == true && var.enable_http && var.create_target_group ? 1 : 0
  load_balancer_arn = aws_alb.alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "#{host}"
      path        = "/"
      query       = "#{query}"
    }
  }

  lifecycle {
    ignore_changes = [default_action]
  }

  depends_on = [aws_alb.alb, aws_alb_target_group.default_tg]
}

resource "aws_route53_record" "alias" {
  zone_id = var.dns_host_zone
  name    = var.wildcard_domain
  type    = "A"

  alias {
    name                   = aws_alb.alb[0].dns_name
    zone_id                = aws_alb.alb[0].zone_id
    evaluate_target_health = true
  }
}
