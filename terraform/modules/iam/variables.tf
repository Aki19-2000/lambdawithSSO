variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = "510278866235"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}
