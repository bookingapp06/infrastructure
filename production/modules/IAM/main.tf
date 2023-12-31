resource "aws_iam_role" "elasticbeanstalk_role" {
  name = "elasticbeanstalk_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ]
  })
}

resource "aws_iam_instance_profile" "elasticbeanstalk_instance_profile" {
  name = "elasticbeanstalk_instance_profile"
  role = aws_iam_role.elasticbeanstalk_role.name
}

resource "aws_iam_role_policy" "eb_role_policy" {
  name = "eb_role_policy"
  role = aws_iam_role.elasticbeanstalk_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
        ],
        // secrets arn from secrets manager, if we destroy/recreate the secret, the last piece of this string will change
        Resource = "arn:aws:secretsmanager:eu-north-1:147017997364:secret:booking_api_production_secrets_v1-muwfjg"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "web_tier" {
  role       = aws_iam_role.elasticbeanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "multicontainre_docker" {
  role       = aws_iam_role.elasticbeanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "worker_tier" {
  role       = aws_iam_role.elasticbeanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}
