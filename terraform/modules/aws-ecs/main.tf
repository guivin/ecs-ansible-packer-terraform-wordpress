resource "aws_ecr_repository" "default" {
  name = "${var.tags["environment"]}-${var.tags["project"]}"
  tags = var.tags
}

resource "aws_ecs_cluster" "default" {
  name = "${var.tags["environment"]}-${var.tags["project"]}"
  tags = var.tags
}

