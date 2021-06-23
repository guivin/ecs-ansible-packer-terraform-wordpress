resource "aws_ecs_cluster" "default" {
  name = local.name
  tags = merge({
	name = local.name
  }, var.tags)
}

resource "aws_cloudwatch_log_group" "default" {
  name = local.name
  tags = merge({
	name = local.name
  }, var.tags)
}

