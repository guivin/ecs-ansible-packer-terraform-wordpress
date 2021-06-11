terraform {
  required_version = "> 0.15.0"
  backend "s3" {
	bucket  = "guivin-terraform-states"
	key     = "dev/ecs-ansible-packer-terraform-wordpress/aws-vpc.tf"
	encrypt = true
	region  = "us-east-1"
  }
}

module "aws-ecs" {
  source = "../../../modules/aws-vpc"
  region = "us-east-1"
  cidr_block = "10.2.0.0/16"
  enable_dns_hostnames = true
  private_subnet_cidr_blocks = [
  	"10.2.1.0/24"
  ]
  public_subnet_cidr_blocks = [
  	"10.2.2.0/24"
  ]
  availability_zones = ["us-east-1a"]
  tags = {
	environment = "dev"
	project = "ecs-wordpress"
  }
}
