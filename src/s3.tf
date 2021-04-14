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