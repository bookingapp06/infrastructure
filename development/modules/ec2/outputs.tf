output "main_api_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main-api[*].id
}

output "main_api_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main-api[*].public_ip
}

output "management_api_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.management-api[*].id
}

output "management_api_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.management-api[*].public_ip
}