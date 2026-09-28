resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.cleanup.function_name}"
  retention_in_days = 14
}
resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  alarm_name        = "cost-optimization-lambda-throttles"
  alarm_description = "Alarm when the cost optimization Lambda is throttled"

  namespace          = "AWS/Lambda"
  metric_name        = "Throttles"
  statistic          = "Sum"
  period             = 300
  evaluation_periods = 1

  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    FunctionName = aws_lambda_function.cleanup.function_name
  }

  alarm_actions = [
    aws_sns_topic.cost_optimization.arn
  ]

  treat_missing_data = "notBreaching"
}