output "domain_name" {
  value = local.domain_name
}

output "hosted_zone_id" {
  value = aws_route53_zone.booking_app_hosted_zone.zone_id
}

output "aws_certificate_manager_certification_arn" {
  value = aws_acm_certificate.booking_app_hosted_certificate.arn
}