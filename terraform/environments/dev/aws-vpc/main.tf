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
  source = "../../../modules/aws-vpc"
  region = "us-east-1"
  cidr_block = "10.2.0.0/16"
  enable_dns_hostnames = true
  private_subnet_cidr_blocks = [
  	"10.2.1.0/24",
	"10.2.2.0/24"
  ]
  public_subnet_cidr_blocks = [
  	"10.2.3.0/24",
	"10.2.4.0/24"
  ]
  availability_zones = ["us-east-1a", "us-east-1b"]
  tags = {
	environment = "dev"
	project = "ecs-wordpress"
  }
}

output "vpc_id" {
  value = module.aws_vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.aws_vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.aws_vpc.public_subnet_ids
}
