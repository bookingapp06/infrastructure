resource "aws_db_parameter_group" "bookingdb_params" {
  name   = "bookingdb-params"
  family = "postgres15"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
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
  username = local.example_secret["BOOKING_API_DB_USERNAME"]
  password = local.example_secret["BOOKING_API_DB_PASSWORD"]
  db_name = local.example_secret["BOOKING_API_DB_NAME"]

  tags = {
    Name = "booking-postgres-db"
  }
}
