resource "aws_lambda_function" "cleanup" {
  function_name = "cost-optimization-cleanup-tf"

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  role = aws_iam_role.lambda_role.arn

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  timeout     = 60
  memory_size = 128

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.cost_optimization.arn
    }
  }
}