# modules/api_gateway/main.tf

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "authorizer_name" {
  description = "The name of the Cognito authorizer"
  type        = string
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "hello-world-api"
  description = "API Gateway for Hello World Lambda"
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = var.authorizer_name  # Use the passed authorizer name here
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_function_name}/invocations"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}
