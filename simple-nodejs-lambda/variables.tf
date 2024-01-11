variable "aws_region_name" {
  type = string
  default = "us-east-1"
}

variable "lambda_function_name" {
  type    = string
  default = "simple-nodejs-lambda"
}

variable "lambda_exec_role_name" {
  type    = string
  default = "nodejs-lambda-basic-exec-role"
}
