output "db_endpoint" {
  description = "The database endpoint for connection"
  value       = aws_db_instance.default.endpoint
}

output "db_address" {
  description = "The database address for connection"
  value       = aws_db_instance.default.address
}

output "db_port" {
  description = "The database port for connection"
  value       = aws_db_instance.default.port
}

output "db_username" {
  description = "The database username for connection"
  value       = var.db_username
}

output "db_password" {
  description = "The database password for connection"
  value       = aws_db_instance.default.password
  sensitive   = true
}

