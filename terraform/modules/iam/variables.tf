variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
variable "account_id" {
  description = "The AWS account ID"
  type        = string
}
