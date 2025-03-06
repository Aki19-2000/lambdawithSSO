resource "aws_lambda_function" "hello_world_function" {
  function_name = "hello-world-function"
  role          = var.lambda_role_arn
  image_uri     = var.image_uri
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
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "hello-world-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE"]
    allow_headers = ["Content-Type", "Authorization"]
    max_age       = 300
  }
}

# Creates a JWT authorizer for API Gateway:
# - Extracts the JWT token from the Authorization header.
# - Uses the Cognito User Pool’s endpoint as the trusted identity provider.
# - Restricts tokens to be issued only for this specific User Pool Client.

resource "aws_apigatewayv2_authorizer" "jwt_authorizer" {
  api_id          = aws_apigatewayv2_api.api_gateway.id
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://cognito-idp.us-east-1.amazonaws.com/${var.user_pool_id}"
    audience = [var.user_pool_client_id]
  }

  name = "jwt-authorizer"
}

# Creates an API stage
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id = aws_apigatewayv2_api.api_gateway.id
  name   = "prod"
  auto_deploy = true
}

# Creates an integration between API Gateway and Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.hello_world_function.invoke_arn
}

# Creates a route for the API Gateway
resource "aws_apigatewayv2_route" "api_route" {
  api_id = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorizer_id = aws_apigatewayv2_authorizer.jwt_authorizer.id
}

# Grants API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

 
