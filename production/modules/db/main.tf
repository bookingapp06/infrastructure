resource "aws_db_instance" "bookingDB" {
  allocated_storage    = 20  # 20 GB is the smallest size for production databases
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.micro"  # db.t3.micro is eligible for the free tier
  identifier           = "bookingdbinstance"
  db_name              = "bookingDB"  # The name of the database to create
  username             = "bookingapi"
  password             = "bookingapi"
  skip_final_snapshot  = true
  publicly_accessible  = false  # Set to false if you don't want the DB to be publicly accessible
  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = "booking-postgres-db"
  }
}
