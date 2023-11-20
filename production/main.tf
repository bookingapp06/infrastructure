terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "production-infrastructure-terraform-state-bucket-booking06"
    key            = "state/terraform.tfstate"
    region         = "eu-north-1"
    # dynamodb_table = "production-infrastructure-terraform-lock-table"
    encrypt        = true
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_secretsmanager_secret_version" "storedSecrets" {
  secret_id = "arn:aws:secretsmanager:eu-north-1:147017997364:secret:booking_api_production_secrets_v1"
}

locals {
  stored_secrets = jsondecode(data.aws_secretsmanager_secret_version.storedSecrets.secret_string)
}

module "database" {
  source = "./modules/db"

  sg_id = module.security_groups.aws_security_group_bookingdbinstance_sg_id
}

module "iam_elasticbeanstalk_role" {
  source = "./modules/IAM"
}

module "elastic_container_repository" {
  source = "./modules/ecr"
}

module "ssh_keys" {
  source = "./modules/ssh"
}

module "s3" {
  source = "./modules/s3"

  ecr_url = module.elastic_container_repository.booking_api_ecr_repository_url
  image_version = var.image_version
}

module "security_groups" {
  source = "./modules/security-groups"
}

resource "aws_elastic_beanstalk_application" "bookingApi" {
  name        = "booking-api"
  description = "Booking api containing both main and management api"
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = "booking-api-production-${var.image_version}"
  application = aws_elastic_beanstalk_application.bookingApi.name
  bucket      = module.s3.s3_ebs_id
  key         = module.s3.s3_ebs_deployment_id
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "production"
  application         = aws_elastic_beanstalk_application.bookingApi.name
  solution_stack_name = "64bit Amazon Linux 2 v3.6.3 running Docker"
  version_label       = aws_elastic_beanstalk_application_version.app_version.name
  tier                = "WebServer"
  wait_for_ready_timeout = "20m"

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }

   setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = module.iam_elasticbeanstalk_role.aws_iam_instance_profile_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_NAME"
    value     = "${module.database.db_name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USERNAME"
    value     = "${module.database.db_username}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PASSWORD"
    value     = "${module.database.db_password}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOST"
    value     = "${module.database.db_address}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = module.ssh_keys.ssh_key_one_name
  }

  // todo: decide if we use this aproach, or add a step into github actions, to log into secrets and pass the secrets as env vars at terraform apply
  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name      = "DB_CREDENTIALS_SECRET_ARN"
  #   value     = "arn:aws:secretsmanager:region:account-id:secret:your-db-credentials-secret-id"
  # }
}