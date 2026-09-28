resource "aws_cloudwatch_event_rule" "cleanup_schedule" {
  name        = "cost-optimization-cleanup-schedule"
  description = "Triggers the cost optimization Lambda periodically"

  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "cleanup_lambda" {
  rule = aws_cloudwatch_event_rule.cleanup_schedule.name
  arn  = aws_lambda_function.cleanup.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cleanup.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cleanup_schedule.arn
}