resource "aws_secretsmanager_secret" "booking_api_production_secrets" {
  name        = "booking_api_production_secrets"
  description = "Booking api secrets stored in AWS Secrets Manager"

#  lifecycle {
#     prevent_destroy = true
#  }
}