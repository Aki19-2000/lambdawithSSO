provider "aws" {
  region = var.aws_region  # Use the region variable from the root module
}

module "iam" {
  source               = "./modules/iam"
  aws_region           = var.aws_region       # Pass region to IAM module
  account_id           = "510278866235"      # Pass account ID to IAM module
  lambda_function_name = var.lambda_function_name  # Pass Lambda function name
}

module "lambda_api" {
  source = "./modules/lambda"
 
  lambda_role_arn     = module.iam_role.lambda_role_arn
  image_name          = var.image_name
  user_pool_id        = module.cognito.user_pool_id
  user_pool_client_id = module.cognito.user_pool_client_id
}
