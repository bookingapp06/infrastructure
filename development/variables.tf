variable "instance_type" {
  description = "The instance type of the EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "The deployment environment: development."
  type        = string
  default     = "development"
}

variable "instance_count" {
  description = "The number of instances to launch."
  type        = number
  default     = 1
}