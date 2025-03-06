variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"  # Default region, change it if needed
}

#variable "account_id" {
  #description = "The AWS account ID"
  #type        = string
#}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "HelloWorldFunction"
}

variable "authorizer_name" {
  description = "The name of the Cognito authorizer"
  type        = string
  default     = "MyCognitoAuthorizer"
}
