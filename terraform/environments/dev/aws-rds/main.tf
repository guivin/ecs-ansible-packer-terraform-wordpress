terraform {
  required_version = "> 0.15.0"
  backend "s3" {
	bucket  = "guivin-terraform-states"
	key     = "dev/ecs-ansible-packer-terraform-wordpress/aws-rds.tf"
	encrypt = true
	region  = "us-east-1"
  }
}

provider "random" {}

data "terraform_remote_state" "aws_vpc" {
  backend = "s3"
  config = {
	bucket = "guivin-terraform-states"
	key    = "dev/ecs-ansible-packer-terraform-wordpress/aws-vpc.tf"
	region = "us-east-1"
  }
}

locals {
  vpc_id             = data.terraform_remote_state.aws_vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.aws_vpc.outputs.private_subnet_ids
}

resource "random_string" "default" {
  length  = 16
  special = true
}

module "aws_rds" {
  source                  = "../../../modules/aws-rds"
  region                  = "us-east-1"
  allowed_security_groups = []
  vpc_id                  = local.vpc_id
  subnet_ids              = local.private_subnet_ids
  db_port                 = 3306
  db_name                 = "wordpress"
  db_allocated_storage    = 5
  db_instance_class       = "db.t2.micro"
  db_storage_type         = "gp2"
  db_username             = "wordpress"
  db_password             = random_string.default.result
  db_engine               = "mariadb"
  db_engine_version       = "10.5"
  db_parameter_group_name = "default.mysql10.5"
  db_skip_final_snapshot  = true
  tags                    = {
	environment = "dev"
	project     = "ecs-wordpress"
  }
}

output "db_endpoint" {
  value = module.aws_rds.db_endpoint
}

