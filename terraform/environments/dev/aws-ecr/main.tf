terraform {
  required_version = "> 0.15.0"
  backend "s3" {
	bucket  = "guivin-terraform-states"
	key     = "dev/ecs-ansible-packer-terraform-wordpress/aws-ecr.tf"
	encrypt = true
	region  = "us-east-1"
  }
}

module "aws-ecr" {
  source = "../../../modules/aws-ecr"
  region = "us-east-1"
  tags   = {
	environment = "dev"
	project     = "ecs-wordpress"
	terraform   = true
  }
}

output "arn" {
  value = module.aws-ecr.arn
}

output "repository_url" {
  value = module.aws-ecr.repository_url
}
