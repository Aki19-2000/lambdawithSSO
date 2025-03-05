variable "aws_region" {
  description = "The AWS region for resources"
  type        = string
}

variable "authorizer_name" {
  description = "The name of the Cognito authorizer"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  type        = string
}
