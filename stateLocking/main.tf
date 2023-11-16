provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "production_terraform_state" {
  bucket = "production-infrastructure-terraform-state-bucket-booking06"
}

# resource "aws_s3_bucket_acl" "production_terraform_state" {
#   bucket = aws_s3_bucket.production_terraform_state.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.production_terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_dynamodb_table" "production_terraform_locks" {
#   name           = "production-infrastructure-terraform-lock-table"
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
