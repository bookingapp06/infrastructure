terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
}

module "ec2_instances" {
  source = "./modules/ec2"

  environment    = var.environment
  instance_type  = var.instance_type
  instance_count = var.instance_count
}