variable "aws_region_name" {
  type    = string
  default = "us-east-1"
}

variable "lambda_function_name" {
  type    = string
  default = "sns-lambda"
}

variable "lambda_exec_role_name" {
  type    = string
  default = "python-lambda-exec-role"
}

variable "sns_topic_name" {
  type    = string
  default = "my-topic"
}