provider "aws" {
  region = var.aws_region
}

module "lambda" {
  source = "./modules/lambda"
  lambda_function_name = var.lambda_function_name
}

module "cognito" {
  source = "./modules/cognito"
  user_pool_name       = var.user_pool_name
  app_client_name      = var.app_client_name
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  lambda_function_name = module.lambda.lambda_function_name
  authorizer_name      = module.cognito.authorizer_name
}
