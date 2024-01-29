data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "lambda_cw_policy" {
  name = "AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "sqs_lambda_policy" {
  name        = var.sqs_lambda_policy_name
  path        = "/"
  description = "SQS Lambda policy"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = var.lambda_exec_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_cw_role_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = data.aws_iam_policy.lambda_cw_policy.arn
}

resource "aws_iam_role_policy_attachment" "sqs_lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.sqs_lambda_policy.arn
}

data "archive_file" "lambda_function_archive_file" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename         = "lambda_function.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_exec_role.arn
  description      = "Simple python based lambda function"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_function_archive_file.output_base64sha256
  runtime          = "python3.12"
  timeout          = 30
  tags = merge(
    local.common_tags,
    {
      Name = var.lambda_function_name
    }
  )
}

resource "aws_lambda_event_source_mapping" "sqs_lambda_esm" {
  event_source_arn = aws_sqs_queue.sqs_queue.arn
  function_name    = aws_lambda_function.lambda_function.arn
}
