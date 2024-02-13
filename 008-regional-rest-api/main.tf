resource "aws_api_gateway_rest_api" "regional_rest_api" {
  name = var.regional_rest_api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = merge(
    local.common_tags,
    {
      Name = var.regional_rest_api_name
    }
  )
}

resource "aws_api_gateway_resource" "test_resource" {
  parent_id   = aws_api_gateway_rest_api.regional_rest_api.root_resource_id
  path_part   = "test"
  rest_api_id = aws_api_gateway_rest_api.regional_rest_api.id
}

resource "aws_api_gateway_method" "test_resource_get_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.test_resource.id
  rest_api_id   = aws_api_gateway_rest_api.regional_rest_api.id
}

resource "aws_api_gateway_integration" "test_resource_get_method_integration" {
  http_method = aws_api_gateway_method.test_resource_get_method.http_method
  resource_id = aws_api_gateway_resource.test_resource.id
  rest_api_id = aws_api_gateway_rest_api.regional_rest_api.id
  type        = "MOCK"
  request_templates = {
    "application/json" = "{'statusCode': 200}"
  }
}

resource "aws_api_gateway_method_response" "method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.regional_rest_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = aws_api_gateway_method.test_resource_get_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "test_resource_get_method_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.regional_rest_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = aws_api_gateway_method.test_resource_get_method.http_method
  status_code = aws_api_gateway_method_response.method_response_200.status_code

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_deployment" "apigw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.regional_rest_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.test_resource.id,
      aws_api_gateway_method.test_resource_get_method.id,
      aws_api_gateway_integration.test_resource_get_method_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "apigw_execution_log_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.regional_rest_api.id}/${var.regional_rest_api_stage_name}"
  retention_in_days = 7
}

resource "aws_api_gateway_stage" "apigw_stage" {
  depends_on    = [aws_cloudwatch_log_group.apigw_execution_log_group]
  deployment_id = aws_api_gateway_deployment.apigw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.regional_rest_api.id
  stage_name    = var.regional_rest_api_stage_name
}

resource "aws_api_gateway_method_settings" "apigw_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.regional_rest_api.id
  stage_name  = aws_api_gateway_stage.apigw_stage.stage_name
  method_path = "*/*"

  settings {
    logging_level      = "INFO"
    metrics_enabled    = true
    data_trace_enabled = true
  }
}