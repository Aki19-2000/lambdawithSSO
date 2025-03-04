# modules/cognito/main.tf

variable "user_pool_name" {
  description = "The name of the Cognito User Pool"
  type        = string
}

variable "app_client_name" {
  description = "The name of the Cognito App Client"
  type        = string
}

resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name
}

resource "aws_cognito_user_pool_client" "app_client" {
  name         = var.app_client_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false  # Set to true if you want a client secret
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name                 = "CognitoAuthorizer"
  rest_api_id          = var.rest_api_id
  authorizer_type      = "COGNITO_USER_POOLS"
  identity_source      = "method.request.header.Authorization"
  provider_arns        = [aws_cognito_user_pool.user_pool.arn]
  authorizer_result_ttl_in_seconds = 300
}

output "authorizer_name" {
  value = aws_api_gateway_authorizer.cognito_authorizer.id
}
