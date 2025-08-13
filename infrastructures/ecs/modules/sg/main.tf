resource "aws_security_group" "public_sg" {
  name   = "${var.project}-public-sg"
  vpc_id = var.vpc

  dynamic "ingress" {
    for_each = var.white_list_ip
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      self        = "false"
      cidr_blocks = [ingress.value]
    }
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name   = "${var.project}-private-sg"
  vpc_id = var.vpc

  dynamic "ingress" {
    for_each = var.white_list_ip
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      self        = "false"
      cidr_blocks = [ingress.value]
    }
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    self            = "true"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow all traffic to ALB port 80 and 443, and allow all traffic from the VPC"
  vpc_id      = var.vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
