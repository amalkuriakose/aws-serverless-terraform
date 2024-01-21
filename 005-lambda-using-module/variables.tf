variable "aws_region_name" {
  type    = string
  default = "us-east-1"
}

variable "lambda_function_name" {
  type    = string
  default = "lambda-using-tf-modules"
}

variable "lambda_role_name" {
  type    = string
  default = "my-lambda-role"
}
