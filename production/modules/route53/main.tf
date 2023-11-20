locals {
  domain_name = "bookingapp06.link"
}


resource "aws_route53_zone" "booking_app_hosted_zone" {
  name = "production-${local.domain_name}"
}

resource "aws_acm_certificate" "booking_app_hosted_certificate" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

// domain name is a set of unique values, we had to change it to a map so we can iterate through them
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.booking_app_hosted_certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      type    = dvo.resource_record_type
      record  = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.booking_app_hosted_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

// foreach above created multiple instances of the certi validation, so we have to loop through them to validate them
resource "aws_acm_certificate_validation" "my_cert" {
  certificate_arn         = aws_acm_certificate.booking_app_hosted_certificate.arn
  validation_record_fqdns = [for k, v in aws_route53_record.cert_validation : v.fqdn]
}