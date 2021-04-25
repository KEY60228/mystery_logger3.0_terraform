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

# DNSレコード (API)
resource "aws_route53_record" "nazolog_api_route53_record" {
    zone_id = aws_route53_zone.nazolog_route53_hostzone.zone_id
    name = "api.${aws_route53_zone.nazolog_route53_hostzone.name}"
    type = "A"

    alias {
        name = aws_lb.nazolog_alb.dns_name
        zone_id = aws_lb.nazolog_alb.zone_id
        evaluate_target_health = true
    }
}

# SSL証明書の検証用リソース (for api)
resource "aws_route53_record" "nazolog_cert_api" {
    name = tolist(aws_acm_certificate.nazolog_cert_api.domain_validation_options)[0].resource_record_name
    type = tolist(aws_acm_certificate.nazolog_cert_api.domain_validation_options)[0].resource_record_type
    records = [ tolist(aws_acm_certificate.nazolog_cert_api.domain_validation_options)[0].resource_record_value ]
    zone_id = aws_route53_zone.nazolog_route53_hostzone.id
    ttl = 60
}

# DNSレコード (images)
resource "aws_route53_record" "nazolog_images_route53_record" {
    zone_id = aws_route53_zone.nazolog_route53_hostzone.zone_id
    name = "images.${aws_route53_zone.nazolog_route53_hostzone.name}"
    type = "A"

    alias {
        name = aws_cloudfront_distribution.nazolog_cloudfront_images.domain_name
        zone_id = aws_cloudfront_distribution.nazolog_cloudfront_images.hosted_zone_id
        evaluate_target_health = true
    }
}

# SSL証明書の検証用リソース (for images)
resource "aws_route53_record" "nazolog_cert_images" {
    name = tolist(aws_acm_certificate.nazolog_cert_images.domain_validation_options)[0].resource_record_name
    type = tolist(aws_acm_certificate.nazolog_cert_images.domain_validation_options)[0].resource_record_type
    records = [ tolist(aws_acm_certificate.nazolog_cert_images.domain_validation_options)[0].resource_record_value ]
    zone_id = aws_route53_zone.nazolog_route53_hostzone.id
    ttl = 60
}

# DNSレコード (mail)
resource "aws_route53_record" "nazolog_mail_route53_record" {
    zone_id = aws_route53_zone.nazolog_route53_hostzone.zone_id
    name = "_amazonses.${aws_route53_zone.nazolog_route53_hostzone.name}"
    type = "TXT"
    ttl = "600"
    records = [ aws_ses_domain_identity.nazolog_ses.verification_token ]
}

# DNSレコード (dkim)
resource "aws_route53_record" "nazolog_dkim_route53_record" {
    count = 3
    zone_id = aws_route53_zone.nazolog_route53_hostzone.zone_id
    name = "${element(aws_ses_domain_dkim.nazolog_dkim.dkim_tokens, count.index)}._domainkey.${aws_route53_zone.nazolog_route53_hostzone.name}"
    type = "CNAME"
    ttl = "600"
    records = [ "${element(aws_ses_domain_dkim.nazolog_dkim.dkim_tokens, count.index)}.dkim.amazonses.com" ]
}