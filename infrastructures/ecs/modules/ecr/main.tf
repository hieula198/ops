resource "aws_ecr_repository" "frontend" {
  name = lower("${var.project}-frontend-service")

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_ecr_repository" "backend" {
  name = lower("${var.project}-backend-service")

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  for_each = toset([
    aws_ecr_repository.frontend.name,
    aws_ecr_repository.backend.name,
  ])

  repository = each.value

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images as other images are uploaded, with a limit of 3 image per tag on production environment."
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["production-"]
          countType     = "imageCountMoreThan"
          countNumber   = 15
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Expire images as other images are uploaded, with a limit of 3 image per tag on staging environment."
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["staging-"]
          countType     = "imageCountMoreThan"
          countNumber   = 3
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 3
        description  = "Expire images as other images are uploaded, with a limit of 3 image per tag on development environment."
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["development-"]
          countType     = "imageCountMoreThan"
          countNumber   = 3
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "frontend" {
  name = "${var.project}-frontend-service-allow-pull-image"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:GetAuthorizationToken"
        ],
        Resource = aws_ecr_repository.frontend.arn
      }
    ]
  })
}

resource "aws_iam_policy" "backend" {
  name = "${var.project}-backend-service-allow-pull-image"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:GetAuthorizationToken"
        ],
        Resource = aws_ecr_repository.backend.arn
      }
    ]
  })
}
