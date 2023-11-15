output "db_username" {
  value = aws_db_instance.bookingDB.username
}

output "db_password" {
  value = aws_db_instance.bookingDB.password
}

output "db_address" {
  value = aws_db_instance.bookingDB.endpoint
}

output "db_name" {
  value = aws_db_instance.bookingDB.db_name
}