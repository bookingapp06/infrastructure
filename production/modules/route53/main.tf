locals {
  domain_name = "bookingapp06.link"
}


resource "aws_route53_zone" "booking_app_hosted_zone" {
  name = local.domain_name
}

resource "aws_acm_certificate" "booking_app_hosted_certificate" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  zone_id = aws_route53_zone.booking_app_hosted_zone.zone_id
  name    = aws_acm_certificate.booking_app_hosted_certificate.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.booking_app_hosted_certificate.domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.booking_app_hosted_certificate.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "my_cert" {
  certificate_arn         = aws_acm_certificate.booking_app_hosted_certificate.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}