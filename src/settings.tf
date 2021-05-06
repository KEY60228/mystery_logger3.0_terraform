# CloudFront用ACM用
provider "aws" {
    alias = "us"
    region = "us-east-1"
}

# tfstateを保存するS3設定
terraform {
    backend "s3" {
        bucket = "nazolog-tfstate-storage"
        key = "terraform.tfstate"
        region = "ap-northeast-1"
    }
}

# CircleCI用IAM user
resource "aws_iam_user" "circleci_user" {
    name = "circleci-user"
}

# CircleCI用IAM policy
resource "aws_iam_policy" "circleci_policy" {
    name = "circleci_policy"
    policy = data.aws_iam_policy_document.circleci_policy.json
}

# CircleCI用IAM policy
data "aws_iam_policy_document" "circleci_policy" {
    statement {
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:ListBucket",
            "s3:DeleteObject",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:BatchGetImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage",
            "ecs:DescribeServices",
            "ecs:DescribeTaskDefinition",
            "ecs:RegistertaskDefinition",
            "ecs:UpdateService",
            "ecs:RunTask",
            "ecs:DescribeTasks",
            "ecs:ListTasks",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [ "*" ]
    }
}

# policyをuserにattach
resource "aws_iam_user_policy_attachment" "circleci_attachment" {
    user = aws_iam_user.circleci_user.name
    policy_arn = aws_iam_policy.circleci_policy.arn
}

# ACCESS KEYの発行
resource "aws_iam_access_key" "nazolog_circleci_key" {
    user = aws_iam_user.circleci_user.name
}

output "aws_iam_circleci_access_key" {
    value     = aws_iam_access_key.nazolog_circleci_key.id
    sensitive = true
}

output "aws_iam_circleci_secret" {
    value     = aws_iam_access_key.nazolog_circleci_key.secret
    sensitive = true
}
