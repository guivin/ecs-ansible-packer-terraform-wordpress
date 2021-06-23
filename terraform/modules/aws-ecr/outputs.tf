output "arn" {
  description = "The ECR ARN"
  value       = aws_ecr_repository.default.arn
}

output "repository_url" {
  description = "The ECR repository URL"
  value       = aws_ecr_repository.default.repository_url
}
