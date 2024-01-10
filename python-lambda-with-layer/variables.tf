variable "lambda_function_name" {
  type    = string
  default = "python-lambda-with-layer"
}

variable "lambda_exec_role_name" {
  type    = string
  default = "python-lambda-basic-exec-role"
}

variable "lambda_layer_name" {
  type    = string
  default = "requests-layer"
}

variable "lambda_layer_bkt_name" {
  type    = string
  default = "test-lambda-layer-zip-files-001"
}
