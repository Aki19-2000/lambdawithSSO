resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name
}

resource "aws_cognito_user_pool_client" "app_client" {
  name         = var.app_client_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name                 = "CognitoAuthorizer"
  rest_api_id          = aws_api_gateway_rest_api.api.id
  authorizer_type      = "COGNITO_USER_POOLS"
  identity_source      = "method.request.header.Authorization"
  provider_arns        = [aws_cognito_user_pool.user_pool.arn]
  authorizer_result_ttl_in_seconds = 300
}

output "authorizer_name" {
  value = aws_api_gateway_authorizer.cognito_authorizer.id
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

