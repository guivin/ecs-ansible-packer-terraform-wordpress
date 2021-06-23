terraform {
  required_version = "> 0.15.0"
  backend "s3" {
	bucket  = "guivin-terraform-states"
	key     = "dev/ecs-ansible-packer-terraform-wordpress/aws-vpc.tf"
	encrypt = true
	region  = "us-east-1"
  }
}

module "aws_vpc" {
  source            = "../../../modules/aws-vpc"
  region            = "us-east-1"
  availability_zone = "us-east-1a"
  tags              = {
	environment = "dev"
	project     = "ecs-wordpress"
	terraform   = true
  }
}

output "vpc_id" {
  value = module.aws_vpc.vpc_id
}

output "availability_zone" {
  value = module.aws_vpc.availability_zone
}

output "subnet_id" {
  value = module.aws_vpc.subnet_id
}

output "sg_id" {
  value = module.aws_vpc.sg_id
}
