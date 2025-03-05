provider "aws" {
  region = var.aws_region  # Use the region variable
}

module "lambda" {
  source              = "./modules/lambda"
  lambda_function_name = "HelloWorldFunction"
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  lambda_function_name = module.lambda.lambda_function_name  # Correctly reference the output
  authorizer_name      = var.authorizer_name                   # Pass authorizer name to API Gateway
  aws_region           = var.aws_region                       # Pass region to API Gateway module
  user_pool_arn        = "arn:aws:cognito-idp:us-east-1:510278866235:userpool/us-east-1_ma5Vf7L4Z"  # Reference the user pool ARN manually
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"  # Set your default region here
}

variable "authorizer_name" {
  description = "The name of the Cognito authorizer"
  type        = string
  default     = "MyCognitoAuthorizer"  # Set your default authorizer name
}
