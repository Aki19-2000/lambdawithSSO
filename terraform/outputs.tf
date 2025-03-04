output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "api_gateway_url" {
  value = module.api_gateway.api_gateway_url
}

output "cognito_user_pool_id" {
  value = module.cognito.user_pool_id
}

