output "vpc_id" {
  description = "The default VPC ID"
  value = aws_default_vpc.default.id
}

output "subnet_id" {
  description = "The default subnet ID"
  value = aws_default_subnet.default.id
}

output "sg_id" {
  description = "The default security group ID"
  value = aws_default_security_group.default.id
}

output "availability_zone" {
  description = "The availability zone to use"
  value = aws_default_subnet.default.availability_zone
}
