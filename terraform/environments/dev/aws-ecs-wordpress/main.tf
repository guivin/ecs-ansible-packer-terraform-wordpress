terraform {
  required_version = "> 0.15.0"
  backend "s3" {
	bucket  = "guivin-terraform-states"
	key     = "dev/aws-ecs-wordpress/aws-ecs-wordpress.tf"
	encrypt = true
	region  = "us-east-1"
  }
}

data "terraform_remote_state" "aws_ecs" {
  backend = "s3"
  config  = {
	bucket = "guivin-terraform-states"
	key    = "dev/ecs-ansible-packer-terraform-wordpress/aws-ecs.tf"
	region = "us-east-1"
  }
}

data "terraform_remote_state" "aws_ecr" {
  backend = "s3"
  config  = {
	bucket = "guivin-terraform-states"
	key    = "dev/ecs-ansible-packer-terraform-wordpress/aws-ecr.tf"
	region = "us-east-1"
  }
}

data "terraform_remote_state" "aws_rds" {
  backend = "s3"
  config  = {
	bucket = "guivin-terraform-states"
	key    = "dev/ecs-ansible-packer-terraform-wordpress/aws-rds.tf"
	region = "us-east-1"
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
  # Networking
  vpc_id                        = data.terraform_remote_state.aws_vpc.outputs.vpc_id
  subnet_id                     = data.terraform_remote_state.aws_vpc.outputs.subnet_id
  sg_id                         = data.terraform_remote_state.aws_vpc.outputs.sg_id
  # RDS
  db_username                   = data.terraform_remote_state.aws_rds.outputs.db_username
  db_host                       = data.terraform_remote_state.aws_rds.outputs.db_address
  db_password                   = data.terraform_remote_state.aws_rds.outputs.db_password
  db_port                       = data.terraform_remote_state.aws_rds.outputs.db_port
  # ECS
  ecs_cloudwatch_log_group_name = data.terraform_remote_state.aws_ecs.outputs.ecs_cloudwatch_group_name
  ecs_cluster_id                = data.terraform_remote_state.aws_ecs.outputs.ecs_cluster_id
  # ECR
  repository_url                = data.terraform_remote_state.aws_ecr.outputs.repository_url
}

module "aws-ecs-wordpress" {
  source                    = "../../../modules/aws-ecs-wordpress"
  region                    = "us-east-1"
  vpc_id                    = local.vpc_id
  subnet_id                 = local.subnet_id
  sg_id                     = local.sg_id
  cloudwatch_log_group_name = local.ecs_cloudwatch_log_group_name
  wordpress_db_host         = local.db_host
  wordpress_db_name         = "wordpress"
  wordpress_db_user         = local.db_username
  wordpress_db_password     = local.db_password
  wordpress_db_port         = local.db_port
  wordpress_port            = 80
  repository_url            = local.repository_url
  image_tag                 = "latest"
  desired_count             = 1
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  fargate_cpu               = 256
  fargate_memory            = 512
  ecs_cluster_id            = local.ecs_cluster_id
  tags                      = {
	environment = "dev"
	project     = "ecs-wordpress"
	terraform   = true
  }
}

output "wordpress_admin_password" {
  description = "The Wordpress admin password"
  value       = module.aws-ecs-wordpress.wordpress_admin_password
  sensitive   = true
}
