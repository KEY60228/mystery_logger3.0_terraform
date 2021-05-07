resource "aws_ses_domain_identity" "nazolog_ses" {
    domain = "mail.mystery-logger.com"
}

resource "aws_ses_domain_dkim" "nazolog_dkim" {
    domain = "mail.mystery-logger.com"
}

# SMTP用IAM userの作成
resource "aws_iam_user" "nazolog_ses_user" {
    name = "nazolog-ses-user"
}

# SMTP用IAM policy
resource "aws_iam_policy" "nazolog_ses_policy" {
    name = "nazolog-ses-policy"
    policy = data.aws_iam_policy_document.nazolog_ses_policy.json
}

data "aws_iam_policy_document" "nazolog_ses_policy" {
    statement {
        effect = "Allow"
        actions = [
            "ses:SendEmail",
            "ses:SendRawEmail",
        ]
        resources = [ "*" ]
    }
}

# policyをuserにattach
resource "aws_iam_user_policy_attachment" "nazolog_ses_attachment" {
    user = aws_iam_user.nazolog_ses_user.name
    policy_arn = aws_iam_policy.nazolog_ses_policy.arn
}

# IAM userのaccess key
resource "aws_iam_access_key" "ses_smtp_key" {
    user = aws_iam_user.nazolog_ses_user.name
}

# access key
output "aws_iam_smtp_access_key" {
    value     = aws_iam_access_key.ses_smtp_key.id
    sensitive = true
}

# secret key
output "aws_iam_smtp_secret" {
    value     = aws_iam_access_key.ses_smtp_key.secret
    sensitive = true
}

# ap-northeast-1用のsmtp password
output "aws_iam_smtp_password_v4" {
    value     = aws_iam_access_key.ses_smtp_key.ses_smtp_password_v4
    sensitive = true
}