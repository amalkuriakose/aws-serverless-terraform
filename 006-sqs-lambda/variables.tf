variable "aws_region_name" {
  type    = string
  default = "us-east-1"
}

variable "lambda_function_name" {
  type    = string
  default = "sqs-lambda"
}

variable "lambda_exec_role_name" {
  type    = string
  default = "python-lambda-exec-role"
}

variable "sqs_queue_name" {
  type    = string
  default = "MyQueue"
}

variable "sqs_lambda_policy_name" {
  type    = string
  default = "sqs-lambda-policy"
}