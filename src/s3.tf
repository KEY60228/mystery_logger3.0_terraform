# ビルドしたReactアプリケーションを置くS3リソース
resource "aws_s3_bucket" "nazolog_s3_front" {
    bucket = "nazolog-front"
    acl = "private"

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    tags = {
        Name = "nazolog-s3-front"
    }
}

# nazolog_frontのaccess blockリソース
resource "aws_s3_bucket_public_access_block" "nazolog_s3_front" {
    bucket = aws_s3_bucket.nazolog_s3_front.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# ポリシーとバケットをアタッチ
resource "aws_s3_bucket_policy" "nazolog_s3_bucket_policy" {
    bucket = aws_s3_bucket.nazolog_s3_front.id
    policy = data.aws_iam_policy_document.nazolog_s3_policy.json
}

# S3ポリシー
data "aws_iam_policy_document" "nazolog_s3_policy" {
    statement {
        actions = ["s3:GetObject"]
        resources = [ "${aws_s3_bucket.nazolog_s3_front.arn}/*" ]

        principals {
            type = "AWS"
            identifiers = [ aws_cloudfront_origin_access_identity.nazolog_cloudfront_oai.iam_arn ]
        }
    }
}

# ALB用ログバケット
resource "aws_s3_bucket" "nazolog_alb_log" {
    bucket = "nazolog-alb-log-bucket"

    lifecycle_rule {
        enabled = true

        expiration {
            days = "180"
        }
    }
}

# ポリシーとバケットのアタッチ
resource "aws_s3_bucket_policy" "nazolog_alb_log_bucket_policy" {
    bucket = aws_s3_bucket.nazolog_alb_log.id
    policy = data.aws_iam_policy_document.nazolog_alb_log_policy.json
}

# ALB用ログバケットのポリシー
data "aws_iam_policy_document" "nazolog_alb_log_policy" {
    statement {
        effect = "Allow"
        actions = [ "s3:PutObject" ]
        resources = [ "arn:aws:s3:::${aws_s3_bucket.nazolog_alb_log.id}/*" ]

        principals {
            type = "AWS"
            identifiers = [ "582318560864" ]
        }
    }
}

# CloudFront用ログバケット
resource "aws_s3_bucket" "nazolog_cloudfront_log" {
    bucket = "nazolog-cloudfront-log-bucket"
    acl = "private"

    lifecycle_rule {
        enabled = true

        expiration {
            days = "180"
        }
    }
}

# CloudFront用ログバケットのaccess blockリソース
resource "aws_s3_bucket_public_access_block" "nazolog_cloudfront_log" {
    bucket = aws_s3_bucket.nazolog_cloudfront_log.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# 画像用S3
resource "aws_s3_bucket" "nazolog_s3_images" {
    bucket = "nazolog-s3-images"

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    tags = {
        Name = "nazolog-s3-images"
    }
}

# ポリシーとバケットのアタッチ (for cloudfront)
resource "aws_s3_bucket_policy" "nazolog_s3_images_policy_for_cloudfront" {
    bucket = aws_s3_bucket.nazolog_s3_images.id
    policy = data.aws_iam_policy_document.nazolog_s3_images_policy_for_cloudfront.json
}

# 画像用S3ポリシー (for cloudfront)
data "aws_iam_policy_document" "nazolog_s3_images_policy_for_cloudfront" {
    statement {
        effect = "Allow"
        actions = [ "s3:GetObject" ]
        resources = [ "arn:aws:s3:::${aws_s3_bucket.nazolog_s3_images.id}/*" ]

        principals {
            type = "AWS"
            identifiers = [ aws_cloudfront_origin_access_identity.nazolog_cloudfront_images_oai.iam_arn ]
        }
    }
}

# ポリシーとバケットのアタッチ (for ecs)
resource "aws_s3_bucket_policy" "nazolog_s3_images_policy_for_ecs" {
    bucket = aws_s3_bucket.nazolog_s3_images.id
    policy = data.aws_iam_policy_document.nazolog_s3_images_policy_for_ecs.json
}

# 画像用S3ポリシー (for ecs)
data "aws_iam_policy_document" "nazolog_s3_images_policy_for_ecs" {
    statement {
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
        ]
        resources = [ "arn:aws:s3:::${aws_s3_bucket.nazolog_s3_images.id}/*" ]

        principals {
            type = "AWS"
            identifiers = [ module.ecs_task_role.iam_role_arn ]
        }
    }
}
