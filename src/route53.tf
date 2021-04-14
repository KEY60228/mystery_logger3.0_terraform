# ホストゾーン
resource "aws_route53_zone" "nazolog_route53_hostzone" {
    name = "mystery-logger.com"

    tags = {
        Name = "nazolog-front-hostzone"
    }
}

# DNSレコード(フロント)
resource "aws_route53_record" "nazolog_route53_record" {
    zone_id = aws_route53_zone.nazolog_route53_hostzone.zone_id
    name = aws_route53_zone.nazolog_route53_hostzone.name
    type = "A"

    alias {
        name = aws_cloudfront_distribution.nazolog_cloudfront.domain_name
        zone_id = aws_cloudfront_distribution.nazolog_cloudfront.hosted_zone_id
        evaluate_target_health = true
    }
}

# SSL証明書の検証用リソース
resource "aws_route53_record" "nazolog_cert" {
    name = tolist(aws_acm_certificate.nazolog_cert.domain_validation_options)[0].resource_record_name
    type = tolist(aws_acm_certificate.nazolog_cert.domain_validation_options)[0].resource_record_type
    records = [ tolist(aws_acm_certificate.nazolog_cert.domain_validation_options)[0].resource_record_value ]
    zone_id = aws_route53_zone.nazolog_route53_hostzone.id
    ttl = 60
}

# # SSL証明書の検証用リソース (for api)
# resource "aws_route53_record" "nazolog_cert_api" {
#     name = tolist(aws_acm_certificate.nazolog_cert_api.domain_validation_options)[0].resource_record_name
#     type = tolist(aws_acm_certificate.nazolog_cert_api.domain_validation_options)[0].resource_record_type
#     records = [ tolist(aws_acm_certificate.nazolog_cert_api.domain_validation_options)[0].resource_record_value ]
#     zone_id = aws_route53_zone.nazolog_route53_hostzone.id
#     ttl = 60
# }
