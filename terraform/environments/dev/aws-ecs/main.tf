terraform {
  required_version = "> 0.15.0"
  backend "s3" {
	bucket  = "guivin-terraform-states"
	key     = "dev/ecs-ansible-packer-terraform-wordpress/aws-ecs.tf"
	encrypt = true
	region  = "us-east-1"
  }
}

module "aws-ecs" {
  source = "../../../modules/aws-ecs"
  region = "us-east-1"
  tags = {
	environment = "dev"
	project = "ecs-wordpress"
  }
}
