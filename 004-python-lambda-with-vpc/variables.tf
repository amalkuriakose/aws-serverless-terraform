variable "aws_region_name" {
  type = string
  default = "us-east-1"
}

variable "lambda_function_name" {
  type    = string
  default = "python-lambda-with-vpc"
}

variable "lambda_exec_role_name" {
  type    = string
  default = "python-lambda-vpc-exec-role"
}

variable "lambda_layer_name" {
  type    = string
  default = "requests-layer"
}

variable "lambda_layer_bkt_name" {
  type    = string
  default = "test-lambda-layer-zip-files-001"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR. Please enter the value in following format X.X.X.X/16."
  default     = "10.10.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 32))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "app_name" {
  type    = string
  default = "test"
}
