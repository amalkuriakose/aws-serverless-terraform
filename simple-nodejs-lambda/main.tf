terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

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
  source_file = "lambda_function.mjs"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename         = "lambda_function.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_exec_role.arn
  description      = "Simple nodejs based lambda function"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_function_archive_file.output_base64sha256
  runtime          = "nodejs20.x"
  tags = merge(
    local.common_tags,
    {
      Name = var.lambda_function_name
    }
  )
}
