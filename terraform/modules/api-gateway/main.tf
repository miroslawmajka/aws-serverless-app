resource "aws_api_gateway_resource" "top_api_resource" {
  path_part   = var.top_api_path
  parent_id   = var.rest_api.root_resource_id
  rest_api_id = var.rest_api.id
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = var.rest_api.id
  resource_id   = aws_api_gateway_resource.top_api_resource.id
  http_method   = var.verb
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = var.rest_api.id
  resource_id             = aws_api_gateway_resource.top_api_resource.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_perm" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
}

# TODO: add CORS and OPTIONS method configuration for production deployment
