provider "aws" {
  region = var.aws_region  # Use the region variable from the root module
}

module "iam" {
  source               = "./modules/iam"
  aws_region           = var.aws_region       # Pass region to IAM module
  account_id           = var.account_id       # Pass account ID to IAM module
  lambda_function_name = var.lambda_function_name  # Pass Lambda function name
}

module "lambda_api" {
  source = "./modules/lambda"
 
  lambda_role_arn     = module.iam.lambda_role_arn
  image_uri           = var.image_uri
  user_pool_id        = module.cognito.user_pool_id
  user_pool_client_id = module.cognito.user_pool_client_id
}

module "cognito" {
  source = "./modules/cognito"
}

output "lambda_function_name" {
  value = module.lambda_api.lambda_function_name
}

output "api_gateway_url" {
  value = "https://${module.lambda_api.api_gateway_id}.execute-api.${var.aws_region}.amazonaws.com/prod"
}
