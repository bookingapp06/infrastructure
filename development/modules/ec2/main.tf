resource "aws_instance" "main-api" {
  count         = var.instance_count
  ami           = "ami-0505148b3591e4c07" 
  instance_type = var.instance_type

  tags = {
    Name = "main-api-${var.environment}-${count.index}"
  }
}

resource "aws_instance" "management-api" {
  count         = var.instance_count
  ami           = "ami-0505148b3591e4c07"
  instance_type = var.instance_type

  tags = {
    Name = "management-api-${var.environment}-${count.index}"
  }
}