provider "aws" {
  region = var.aws_region  # Use the region variable
}

module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name  = "myLambdaFunction"
  iam_role_arn          = module.iam.lambda_role_arn
  image_uri             = "510278866235.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest"
  environment           = "dev"
  api_stage             = "prod"
  account_id            = "510278866235"
  region                = var.region  # Pass region to the lambda module
}

module "iam" {
  source              = "./modules/iam"
  aws_region          = var.aws_region
  account_id          = var.account_id
  lambda_function_name = "myLambdaFunction"
}


module "api_gateway" {
  source               = "./modules/api_gateway"
  lambda_function_name = module.lambda.lambda_function_name  # Correctly reference the output
  authorizer_name      = var.authorizer_name                   # Pass authorizer name to API Gateway
  aws_region           = var.aws_region                       # Pass region to API Gateway module
  user_pool_arn        = "arn:aws:cognito-idp:us-east-1:510278866235:userpool/us-east-1_ma5Vf7L4Z"  # Reference the user pool ARN manually
}

variable "authorizer_name" {
  description = "The name of the Cognito authorizer"
  type        = string
  default     = "MyCognitoAuthorizer"  # Set your default authorizer name
}
