# modules/api_gateway/main.tf

variable "authorizer_name" {
  description = "The name of the Cognito authorizer"
  type        = string
}
variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  type        = string
}

variable "aws_region" {
  description = "The AWS region for resources"
  type        = string
}


# Ensure the Cognito User Pool is defined in the root module and passed correctly.
resource "aws_api_gateway_rest_api" "api" {
  name        = "hello-world-api"
  description = "API Gateway for Hello World Lambda"
}

# Ensure that the root resource is created before method and integration
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name                 = var.authorizer_name
  rest_api_id          = aws_api_gateway_rest_api.api.id
  type                 = "COGNITO_USER_POOLS"  # Corrected the argument name
  identity_source      = "method.request.header.Authorization"
  provider_arns        = [var.user_pool_arn]  # Use the user pool ARN
  authorizer_result_ttl_in_seconds = 300
}



# Create the API Gateway method (GET)
resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id  # Pass the correct authorizer_id here
  
  depends_on = [
    aws_api_gateway_authorizer.cognito_authorizer
  ]
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.lambda.lambda_function_arn}/invocations"
}


# API Gateway Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

# Define API Gateway Stage (prod)
resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.api.id  # Output the rest_api_id for use by other modules
}
