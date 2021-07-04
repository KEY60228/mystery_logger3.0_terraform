# ECSのログ収集リソース
resource "aws_cloudwatch_log_group" "nazolog_ecs_logs" {
    name = "/ecs/nazolog"
    retention_in_days = 180
}

# ECS Service Auto Scaling Scaleout用 CloudWatch trigger
resource "aws_cloudwatch_metric_alarm" "nazolog_ecs_service_cpu_high" {
    alarm_name = "nazolog-ecs-service-cpu-high"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 1
    metric_name = "CPUUtilization"
    namespace = "AWS/ECS"
    period = "60"
    statistic = "Average"
    threshold = 70

    dimensions = {
        ClusterName = "nazolog-ecs-cluster"
        ServiceName = "nazolog-ecs-service"
    }

    alarm_actions = [ aws_appautoscaling_policy.nazolog_ecs_service_autoscaling_out_policy.arn ]
}

# ECS Service Auto Scaling Scalein用 CloudWatch trigger
resource "aws_cloudwatch_metric_alarm" "nazolog_ecs_service_cpu_low" {
    alarm_name = "nazolog-ecs-service-cpu-low"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = 1
    metric_name = "CPUUtilization"
    namespace = "AWS/ECS"
    period = "60"
    statistic = "Average"
    threshold = 30

    dimensions = {
        ClusterName = "nazolog-ecs-cluster"
        ServiceName = "nazolog-ecs-service"
    }

    alarm_actions = [ aws_appautoscaling_policy.nazolog_ecs_service_autoscaling_in_policy.arn ]
}

# lambdaのログ収集リソース
resource "aws_cloudwatch_log_group" "nazolog_lambda_logs" {
    name = "/lambda/nazolog"
    retention_in_days = 30
}
