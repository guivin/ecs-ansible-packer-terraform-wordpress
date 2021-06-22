output "cluster_id" {
  description = "The ECS cluster ID"
  value = aws_ecs_cluster.default.id
}

output "cloudwatch_group_name" {
  description = "The Cloudwatch group name to store container logs"
  value = aws_cloudwatch_log_group.default.name
}
