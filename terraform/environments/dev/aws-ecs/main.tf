terraform {
  required_version = "> 0.15.0"
  backend "s3" {
	bucket  = "guivin-terraform-states"
	key     = "dev/ecs-ansible-packer-terraform-wordpress/aws-ecs.tf"
	encrypt = true
	region  = "us-east-1"
  }
}

module "aws_ecs" {
  source = "../../../modules/aws-ecs"
  region = "us-east-1"
  tags   = {
	environment = "dev"
	project     = "ecs-wordpress"
	terraform   = true
  }
}

output "ecs_cluster_id" {
  value = module.aws_ecs.cluster_id
}

output "ecs_cloudwatch_group_name" {
  value = module.aws_ecs.cloudwatch_group_name
}
