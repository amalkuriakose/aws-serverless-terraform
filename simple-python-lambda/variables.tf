variable "aws_region_name" {
  type = string
  default = "us-east-1"
}

variable "lambda_function_name" {
  type    = string
  default = "simple-python-lambda"
}

variable "lambda_exec_role_name" {
  type    = string
  default = "python-lambda-basic-exec-role"
}
