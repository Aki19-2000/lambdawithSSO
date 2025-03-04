# modules/lambda/main.tf

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

resource "aws_lambda_function" "hello_world" {
  function_name = var.lambda_function_name  # Use the passed name for the Lambda function
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  
  code {
    zip_file = <<ZIP
import json

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Hello World!')
    }
ZIP
  }

  environment {
    variables = {
      KEY = "value"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect   = "Allow"
        Sid      = ""
      }
    ]
  })
}

output "lambda_function_name" {
  value = aws_lambda_function.hello_world.function_name
}
