resource "aws_default_vpc" "default" {
  tags = merge({
	name = local.name
  }, var.tags)
}

resource "aws_default_subnet" "default" {
  availability_zone = var.availability_zone
  tags              = merge({
	name = local.name
  }, var.tags)
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  egress {
	from_port   = 0
	to_port     = 0
	protocol    = "-1"
	cidr_blocks = [
	  "0.0.0.0/0"]
  }
  tags = merge({
	name = local.name
  }, var.tags)
}
