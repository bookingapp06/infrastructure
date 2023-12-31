output "domain_name" {
  value = local.domain_name
}

output "subdomains" {
  value = local.subdomains
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.booking_app_hosted_zone.zone_id
}

output "aws_certificate_manager_certification_arn" {
  value = aws_acm_certificate.booking_app_hosted_certificate.arn
}