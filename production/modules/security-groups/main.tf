resource "aws_security_group" "bookingdbinstance_sg" {
  name        = "bookingdbinstance"
  description = "Allow inbound PostgreSQL traffic"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# resource "aws_security_group" "ec2_to_bookingdbinstance_sg" {
#   name        = "ec2_to_bookingdbinstance_sg"
#   description = "Allow outbound PostgreSQL traffic"

#   egress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.main.cidr_block]  # Adjust this based on your security requirements
#   }
# }