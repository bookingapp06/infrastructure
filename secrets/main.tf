provider "aws" {
  region = "eu-north-1"
}

resource "aws_secretsmanager_secret" "booking_api_production_secrets_v1" {
  name        = "booking_api_production_secrets_v1"
  description = "Booking api secrets stored in AWS Secrets Manager"

 lifecycle {
    prevent_destroy = true
 }
}