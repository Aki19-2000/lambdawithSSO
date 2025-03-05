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

variable "app_client_name" {
  description = "Name of the Cognito App Client"
  default     = "HelloWorldAppClient"
}
