terraform {
  required_version = ">=1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.32.1"
    }
  }
  backend "s3" {
    bucket  = "your-terraform-state-bucket" # Replace with your S3 bucket name
    key     = "infrastructure/terraform.tfstate"
    region  = "us-east-1"
    profile = "profile_name" # Replace with your AWS profile name
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      CreatedBy = var.aws_profile
      Terraform = "true"
    }
  }
}