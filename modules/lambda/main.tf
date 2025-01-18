# IAM Role for Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name               = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for Lambda to Manage IAM Users
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "${var.lambda_function_name}-policy"
  role   = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "iam:ListUsers",
          "iam:UpdateUser",
          "iam:GetUser",
          "iam:DeleteLoginProfile",
          "iam:ListAccessKeys",
          "iam:UpdateAccessKey"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "logs:*"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "disable_inactive_users" {
  function_name = var.lambda_function_name
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "${path.module}/python.zip"
  timeout       = 60

  # Set environment variables
  environment {
    variables = {
      INACTIVE_DAYS_THRESHOLD = tostring(var.inactive_days_threshold)
    }
  }
}

# Schedule Lambda Execution (Daily)
resource "aws_cloudwatch_event_rule" "daily_schedule" {
  name                = "${var.lambda_function_name}-schedule"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_schedule.name
  target_id = var.lambda_function_name
  arn       = aws_lambda_function.disable_inactive_users.arn
}

# Allow CloudWatch to Trigger Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.disable_inactive_users.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_schedule.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.disable_inactive_users.arn
}