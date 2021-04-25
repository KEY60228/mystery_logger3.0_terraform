resource "aws_ses_domain_identity" "nazolog_ses" {
    domain = "mail.mystery-logger.com"
}

resource "aws_ses_domain_dkim" "nazolog_dkim" {
    domain = "mail.mystery-logger.com"
}