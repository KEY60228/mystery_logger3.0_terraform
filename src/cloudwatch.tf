# ECSのログ収集リソース
resource "aws_cloudwatch_log_group" "nazolog_ecs_logs" {
    name = "/ecs/nazolog"
    retention_in_days = 180
}