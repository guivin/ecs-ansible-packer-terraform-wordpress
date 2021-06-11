


resource "aws_security_group" "default" {
  name        = "${var.tags["environment"]}-${var.tags["project"]}-rds"
  description = "Allow inbound access in port 3306 only"
  vpc_id      = var.vpc_id

  ingress {
	protocol        = "tcp"
	from_port       = var.db_port
	to_port         = var.db_port
	security_groups = var.allowed_security_groups
  }

  egress {
	protocol    = "-1"
	from_port   = 0
	to_port     = 0
	cidr_blocks = [
	  "0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "wordpress-rds-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "default" {
  allocated_storage      = var.db_allocated_storage
  storage_type           = var.db_storage_type
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = var.db_parameter_group_name
  vpc_security_group_ids = [
	aws_security_group.default.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = var.db_skip_final_snapshot
}
