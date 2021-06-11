terraform {
  required_version = "> 0.15.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "default" {
  bucket = "guivin-terraform-states"
  acl    = "private"

  versioning {
	enabled = true
  }

  server_side_encryption_configuration {
	rule {
	  apply_server_side_encryption_by_default {
		sse_algorithm = "AES256"
	  }
	}
  }
  tags   = {
	environment = "dev"
	project     = "ecs-wordpress"
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls   = true
  block_public_policy = true
}
