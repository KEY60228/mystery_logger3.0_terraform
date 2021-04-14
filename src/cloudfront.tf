# PrivateなS3 Bucketにアクセスするためにオリジンアクセスアイデンティティを利用する
resource "aws_cloudfront_origin_access_identity" "nazolog_cloudfront_oai" {
    comment = "mystery-logger.com"
}

# CloudFrontのディストリビューション設定
resource "aws_cloudfront_distribution" "nazolog_cloudfront" {
    aliases = [ "mystery-logger.com" ]
    
    origin {
        domain_name = aws_s3_bucket.nazolog_s3_front.bucket_regional_domain_name
        origin_id = "s3-origin-mystery-logger.com"

        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.nazolog_cloudfront_oai.cloudfront_access_identity_path
        }
    }

    enabled = true
    is_ipv6_enabled = true
    comment = "mystery-logger.com"
    default_root_object = "index.html"

    default_cache_behavior {
        allowed_methods = [ "GET", "HEAD" ]
        cached_methods = [ "GET", "HEAD" ]
        target_origin_id = "s3-origin-mystery-logger.com"

        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    price_class = "PriceClass_200"

    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate.nazolog_cert.arn
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1"
    }
}