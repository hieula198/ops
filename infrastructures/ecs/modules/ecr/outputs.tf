output "frontend_repo" {
  value = aws_ecr_repository.frontend.name
}

output "frontend_repo_arn" {
  value = aws_ecr_repository.frontend.arn
}

output "frontend_pull_policy" {
  value = aws_iam_policy.frontend.arn
}

output "backend_repo" {
  value = aws_ecr_repository.backend.name
}

output "backend_repo_arn" {
  value = aws_ecr_repository.backend.arn
}

output "backend_pull_policy" {
  value = aws_iam_policy.backend.arn
}
