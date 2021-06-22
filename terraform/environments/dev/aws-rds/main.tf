terraform {
  required_version = "> 0.15.0"
  backend "s3" {
	bucket  = "guivin-terraform-states"
	key     = "dev/ecs-ansible-packer-terraform-wordpress/aws-rds.tf"
	encrypt = true
	region  = "us-east-1"
  }
}

data "terraform_remote_state" "aws_vpc" {
  backend = "s3"
  config  = {
	bucket = "guivin-terraform-states"
	key    = "dev/ecs-ansible-packer-terraform-wordpress/aws-vpc.tf"
	region = "us-east-1"
  }
}

locals {
  vpc_id    = data.terraform_remote_state.aws_vpc.outputs.vpc_id
  subnet_id = data.terraform_remote_state.aws_vpc.outputs.subnet_id
  sg_id     = data.terraform_remote_state.aws_vpc.outputs.sg_id
}

module "aws_rds" {
  source                  = "../../../modules/aws-rds"
  vpc_id                  = local.vpc_id
  region                  = "us-east-1"
  availability_zone       = "us-east-1a"
  allowed_security_groups = [
	local.sg_id]
  db_port                 = 3306
  db_name                 = "wordpress"
  db_allocated_storage    = 5
  db_instance_class       = "db.t2.micro"
  db_storage_type         = "gp2"
  db_username             = "wordpress"
  db_engine               = "mariadb"
  db_engine_version       = "10.5"
  db_parameter_group_name = "default.mysql10.5"
  db_skip_final_snapshot  = true
  tags                    = {
	environment = "dev"
	project     = "ecs-wordpress"
	terraform   = true
  }
}

output "db_endpoint" {
  value = module.aws_rds.db_endpoint
}

output "db_address" {
  value = module.aws_rds.db_address
}

output "db_port" {
  value = module.aws_rds.db_port
}

output "db_username" {
  value = module.aws_rds.db_username
}

output "db_password" {
  value     = module.aws_rds.db_password
  sensitive = true
}
