# ECRレポジトリ
resource "aws_ecr_repository" "nazolog_ecr" {
    name = "nazolog-ecr"
}

# ライフサイクルポリシー
resource "aws_ecr_lifecycle_policy" "nazolog_ecr_policy" {
    repository = aws_ecr_repository.nazolog_ecr.name

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
