resource "aws_ecr_repository" "booking_api_ecr_repository" {
  name                 = "booking-api-ecr"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "deletion_policy" {
  repository = aws_ecr_repository.booking_api_ecr_repository.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 5 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
