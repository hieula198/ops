####################################
# Module: Route53 and CloudFront for Wildcard Domain
# This module sets up a CloudFront distribution with a wildcard domain and an ACM certificate.
# It also creates the necessary Route53 records for DNS validation and aliasing.
####################################

resource "aws_acm_certificate" "cloudfront_cert" {
  domain_name       = var.wildcard_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.dns_host_zone
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}

####################################
# Module: Route53 and CloudFront for Wildcard Domain
# This module sets up a CloudFront distribution with a wildcard domain and an ACM certificate.
# It also creates the necessary Route53 records for DNS validation and aliasing.
####################################

resource "aws_cloudfront_distribution" "wildcard" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Wildcard distribution for ${var.wildcard_domain} (${var.project} project)"
  default_root_object = ""

  aliases = [var.wildcard_domain]

  origin {
    domain_name = var.alb_dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:354024168685:certificate/d440cd34-1ac3-4d5b-a03f-68a9e50b3417"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# resource "aws_route53_record" "wildcard_record" {
#   zone_id = var.dns_host_zone
#   name    = var.wildcard_domain
#   type    = "A"
#
#   alias {
#     name                   = aws_cloudfront_distribution.wildcard.domain_name
#     zone_id                = aws_cloudfront_distribution.wildcard.hosted_zone_id
#     evaluate_target_health = false
#   }
# }