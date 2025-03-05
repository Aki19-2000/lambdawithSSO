# variables.tf (Root Module)

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "HelloWorldFunction"
}

variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  default     = "HelloWorldUserPool"
}

variable "app_client_name" {
  description = "Name of the Cognito App Client"
  default     = "HelloWorldAppClient"
}
