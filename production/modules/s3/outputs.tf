output "s3_ebs_id" {
  value = aws_s3_bucket.ebs.id
}

output "s3_ebs_deployment_id" {
  value = aws_s3_object.ebs_deployment.id
}