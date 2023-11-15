variable "instance_type" {
  description = "The instance type of the EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "The deployment environment: production."
  type        = string
  default     = "production"
}

variable "instance_count" {
  description = "The number of instances to launch."
  type        = number
  default     = 1
}

variable "image_version" {
  description = "The version of the image"
  type        = string
}