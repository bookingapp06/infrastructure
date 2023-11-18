output "aws_security_group_bookingdbinstance_sg_id" {
  value = aws_security_group.bookingdbinstance_sg.id
}

output "aws_security_group_ec2_to_bookingdbinstance_sg_id" {
  value = aws_security_group.ec2_to_bookingdbinstance_sg.id
}