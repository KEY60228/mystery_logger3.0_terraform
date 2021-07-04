resource "aws_sqs_queue" "nazolog_sqs" {
    name = "nazolog_sqs.fifo"
    fifo_queue = true
    content_based_deduplication = true
}

resource "aws_lambda_event_source_mapping" "lambda_sqs_mapping" {
    event_source_arn = aws_sqs_queue.nazolog_sqs.arn
    function_name = aws_lambda_function.nazolog_ses_function.arn
}
