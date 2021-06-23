locals {
  name = "${var.tags["environment"]}-${var.tags["project"]}-ecs"
}
