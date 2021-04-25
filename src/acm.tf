# SSL証明書の発行
resource "aws_acm_certificate" "nazolog_cert" {
    provider = aws.us
    domain_name = "mystery-logger.com"
    subject_alternative_names = []
    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

# SSL証明書の検証完了まで待機
resource "aws_acm_certificate_validation" "nazolog_cert_validation" {
    provider = aws.us
    certificate_arn = aws_acm_certificate.nazolog_cert.arn
    validation_record_fqdns = [ aws_route53_record.nazolog_cert.fqdn ]
}

# SSL証明書の発行
resource "aws_acm_certificate" "nazolog_cert_api" {
    domain_name = "api.mystery-logger.com"
    subject_alternative_names = []
    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

# SSL証明書の検証完了まで待機
resource "aws_acm_certificate_validation" "nazolog_cert_api_validation" {
    certificate_arn = aws_acm_certificate.nazolog_cert_api.arn
    validation_record_fqdns = [ aws_route53_record.nazolog_cert_api.fqdn ]
}

# SSL証明書の発行
resource "aws_acm_certificate" "nazolog_cert_images" {
    provider = aws.us
    domain_name = "images.mystery-logger.com"
    subject_alternative_names = []
    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

# SSL証明書の検証完了まで待機
resource "aws_acm_certificate_validation" "nazolog_cert_images_validation" {
    provider = aws.us
    certificate_arn = aws_acm_certificate.nazolog_cert_images.arn
    validation_record_fqdns = [ aws_route53_record.nazolog_cert_images.fqdn ]
}
