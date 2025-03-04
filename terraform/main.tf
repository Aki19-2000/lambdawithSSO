# main.tf (Root Module)

provider "aws" {
  region = var.aws_region
}

module "lambda" {
  source              = "./modules/lambda"
  lambda_function_name = "HelloWorldFunction"  # Pass Lambda function name to the module
}

module "cognito" {
  source          = "./modules/cognito"
  user_pool_name  = "HelloWorldUserPool"
  app_client_name = "HelloWorldAppClient"
}

module "api_gateway" {
  source             = "./modules/api_gateway"
  lambda_function_name = module.lambda.lambda_function_name  # Pass Lambda function name to API Gateway
  authorizer_name      = module.cognito.authorizer_name      # Pass authorizer name to API Gateway
}
