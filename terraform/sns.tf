resource "aws_sns_topic" "cost_optimization" {
  name = "cost-optimization-notifications"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.cost_optimization.arn
  protocol  = "email"
  endpoint  = var.notification_email
}