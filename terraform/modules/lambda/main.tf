resource "aws_lambda_function" "hello_world_function" {
  function_name = "hello-world-function"
  role          = var.lambda_role_arn
  image_uri     = var.image_name
  package_type  = "Image"

  environment {
    variables = {
      ENV = "prd"
    }
  }

 

  # Enabling X-Ray tracing
  tracing_config {
    mode = "Active"  # This enables X-Ray tracing for the Lambda function
  }
}

