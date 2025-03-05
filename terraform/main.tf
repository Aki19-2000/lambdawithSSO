provider "aws" {
  region = var.aws_region  # Use the region variable
}

module "iam" {
  source               = "./modules/iam"
  aws_region           = var.region          # Pass region to IAM module
  account_id           = "510278866235"      # Pass account ID to IAM module
  lambda_function_name = var.lambda_function_name  # Pass Lambda function name
}

module "lambda" {
  source               = "./modules/lambda"
  region               = var.region          # Pass region to Lambda module
  lambda_function_name = var.lambda_function_name  # Pass Lambda function name
  iam_role_arn         = module.iam.lambda_role_arn   # Pass IAM role ARN
  image_uri            = "510278866235.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest"  # Example URI
  environment          = "dev"                # Lambda environment
  api_stage            = "prod"               # API Gateway stage
  account_id           = "510278866235"      # Pass AWS account ID to Lambda module
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
