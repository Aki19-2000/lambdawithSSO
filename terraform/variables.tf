variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"  # Default region, change it if needed
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = "510278866235"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "HelloWorldFunction"
}

variable "authorizer_name" {
  description = "The name of the Cognito authorizer"
  type        = string
  default     = "MyCognitoAuthorizer"
}
