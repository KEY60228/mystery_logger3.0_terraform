# lambda用IAM role
module "lambda_ses_and_sqs_role" {
    source = "./iam_role"
    name = "lambda_ses_and_sqs_role"
    policy = data.aws_iam_policy_document.lambda_ses_and_sqs_policy.json
    identifier = "lambda.amazonaws.com"
}

# AWSLambdaBasicExecutionRole
data "aws_iam_policy" "lambda_basic_execution" {
    arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# lambda用IAM policy
data "aws_iam_policy_document" "lambda_ses_and_sqs_policy" {
    source_json = data.aws_iam_policy.lambda_basic_execution.policy

    statement {
        effect = "Allow"
        actions = [
            "ses:SendEmail",
            "ses:SendRawEmail",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes",
        ]
        resources = [ "*" ]
    }
}

# lambda関数
resource "aws_lambda_function" "nazolog_ses_function" {
    function_name = "nazolog_ses_function"
    role = module.lambda_ses_and_sqs_role.iam_role_arn
    handler = "mail"
    runtime = "go1.x"

    filename = "./func/mail.zip"
    source_code_hash = filebase64sha256("./func/mail.zip")
}
