output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "api_gateway_url" {
  value = "https://${module.api_gateway.rest_api_id}.execute-api.${var.aws_region}.amazonaws.com/prod"
}
