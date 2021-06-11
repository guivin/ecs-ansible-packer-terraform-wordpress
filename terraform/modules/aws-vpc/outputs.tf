output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.default.id
}

output "public_subnet_ids" {
  description = "List of public subnet id"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "List of private subnet id"
  value       = aws_subnet.private.*.id
}
