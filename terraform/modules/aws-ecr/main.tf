resource "aws_ecr_repository" "default" {
  name = "${var.tags["environment"]}-${var.tags["project"]}"
  tags = var.tags
}
