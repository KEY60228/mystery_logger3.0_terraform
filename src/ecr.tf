# ECRレポジトリ
resource "aws_ecr_repository" "nazolog_ecr_php" {
    name = "nazolog-ecr-php"
}

# ライフサイクルポリシー
resource "aws_ecr_lifecycle_policy" "nazolog_ecr_php_policy" {
    repository = aws_ecr_repository.nazolog_ecr_php.name

    policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 release tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["release"],
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

# ECRレポジトリ
resource "aws_ecr_repository" "nazolog_ecr_nginx" {
    name = "nazolog-ecr-nginx"
}

# ライフサイクルポリシー
resource "aws_ecr_lifecycle_policy" "nazolog_ecr_nginx_policy" {
    repository = aws_ecr_repository.nazolog_ecr_nginx.name

    policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 release tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["release"],
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
