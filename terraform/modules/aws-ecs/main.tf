resource "aws_ecs_cluster" "default" {
  name = "${var.tags["environment"]}-${var.tags["project"]}"
  tags = var.tags
}

