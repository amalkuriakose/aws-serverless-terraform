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

data "aws_iam_policy" "lambda_exec_policy" {
  name = "AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = var.lambda_exec_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_exec_role_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = data.aws_iam_policy.lambda_exec_policy.arn
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
  runtime          = "python3.12" # Change the compatable runtime based on your preference
  layers           = [aws_lambda_layer_version.lambda_layer.arn]
  tags = merge(
    local.common_tags,
    {
      Name = var.lambda_function_name
    }
  )
}
