module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.7.1"

  function_name = var.lambda_function_name
  description   = "Lambda function created using terraform modules"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  source_path   = "${path.module}/lambda_function.py"
  role_name     = var.lambda_role_name
  tags          = local.common_tags
}