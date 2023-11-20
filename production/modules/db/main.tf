resource "aws_db_parameter_group" "bookingdb_params" {
  name   = "bookingdb-params"
  family = "postgres15"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

data "aws_secretsmanager_secret_version" "storedSecrets" {
  secret_id = "arn:aws:secretsmanager:eu-north-1:147017997364:secret:booking_api_production_secrets_v1"
}

locals {
  stored_secrets = jsondecode(data.aws_secretsmanager_secret_version.storedSecrets.secret_string)
}

resource "aws_db_instance" "bookingDB" {
  allocated_storage    = 20  # 20 GB is the smallest size for production databases
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.micro"  # db.t3.micro is eligible for the free tier
  identifier           = "bookingdbinstance"
  skip_final_snapshot  = true
  publicly_accessible  = false  # Set to false if you don't want the DB to be publicly accessible
  vpc_security_group_ids = [var.sg_id]
  parameter_group_name = aws_db_parameter_group.bookingdb_params.name
  username = local.stored_secrets["BOOKING_API_DB_USERNAME"]
  password = local.stored_secrets["BOOKING_API_DB_PASSWORD"]
  db_name = local.stored_secrets["BOOKING_API_DB_NAME"]

  tags = {
    Name = "booking-postgres-db"
  }
}
