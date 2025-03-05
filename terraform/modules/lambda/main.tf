resource "aws_lambda_function" "this" {
  function_name = var.lambda_function_name
  role          = var.iam_role_arn
  package_type  = "Image"
  image_uri     = var.image_uri

  environment {
    variables = {
      ENV = var.environment
    }
  }

  # Enabling X-Ray tracing
  tracing_config {
    mode = "Active"  # This enables X-Ray tracing for the Lambda function
  }
}

