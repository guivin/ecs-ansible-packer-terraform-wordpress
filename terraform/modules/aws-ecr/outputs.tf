output "arn" {
  value = aws_ecr_repository.default.arn
}

output "repository_url" {
  value = aws_ecr_repository.default.repository_url
}
