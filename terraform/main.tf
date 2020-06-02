# TODO: refactor into modules and variables

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Terraform backend for storing state will be in S3 but povided in a separate "tfconfig" file
terraform {
  backend "s3" {}
}

################################
# STEP 1 - S3 Deployments Bucket
################################

resource "aws_s3_bucket" "lambda_deployments_bucket" {
  bucket        = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  force_destroy = true
}

##########################
# STEP 2 - Lambda Functions
###########################

data "archive_file" "lambda_dummy_node_zip" {
  type        = "zip"
  output_path = "/tmp/lambda-dummy-node.zip"
  source {
    content  = file("${path.root}/dummy-lambda/node/index.js")
    filename = "index.js"
  }
}

data "archive_file" "lambda_dummy_python_zip" {
  type        = "zip"
  output_path = "/tmp/lambda-dummy-python.zip"
  source {
    content  = file("${path.root}/dummy-lambda/python/main.py")
    filename = "main.py"
  }
}

resource "aws_s3_bucket_object" "lambda_dummy_node_object" {
  bucket     = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  key        = "lambda-dummy-node.zip"
  source     = "/tmp/lambda-dummy-node.zip"
  depends_on = [data.archive_file.lambda_dummy_node_zip, aws_s3_bucket.lambda_deployments_bucket]
}

resource "aws_s3_bucket_object" "lambda_dummy_python_object" {
  bucket     = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  key        = "lambda-dummy-python.zip"
  source     = "/tmp/lambda-dummy-python.zip"
  depends_on = [data.archive_file.lambda_dummy_python_zip, aws_s3_bucket.lambda_deployments_bucket]
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "lambda-role-${terraform.workspace}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda_node_function" {
  function_name = "aws-serverless-app-node-function-${terraform.workspace}"
  runtime       = "nodejs12.x"
  handler       = "index.handler"
  role          = aws_iam_role.iam_for_lambda.arn
  s3_bucket     = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  s3_key        = "lambda-dummy-node.zip"
  depends_on    = [aws_s3_bucket_object.lambda_dummy_node_object]
}

resource "aws_lambda_function" "lambda_python_function" {
  function_name = "aws-serverless-app-python-function-${terraform.workspace}"
  runtime       = "python3.8"
  handler       = "main.handler"
  role          = aws_iam_role.iam_for_lambda.arn
  s3_bucket     = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  s3_key        = "lambda-dummy-python.zip"
  depends_on    = [aws_s3_bucket_object.lambda_dummy_python_object]
}

######################
# STEP 3 - API Gateway
######################

resource "aws_api_gateway_rest_api" "serverless_api" {
  name        = "aws-serverless-app-rest-api-${terraform.workspace}"
  description = "REST API for the ${terraform.workspace} environment"
  depends_on  = [aws_lambda_function.lambda_node_function, aws_lambda_function.lambda_python_function]
}

resource "aws_api_gateway_resource" "resource_node" {
  path_part   = "hello-node"
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
}

resource "aws_api_gateway_resource" "resource_python" {
  path_part   = "hello-python"
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
}

resource "aws_api_gateway_method" "method_node" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.resource_node.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "method_python" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.resource_python.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "node_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.resource_node.id
  http_method             = aws_api_gateway_method.method_node.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_node_function.invoke_arn
}

resource "aws_api_gateway_integration" "python_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.resource_python.id
  http_method             = aws_api_gateway_method.method_python.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_python_function.invoke_arn
}

resource "aws_lambda_permission" "apigw_node_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_node_function.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "apigw_python_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_python_function.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_deployment" "dynamic_deployment" {
  depends_on  = [aws_api_gateway_integration.python_lambda_integration, aws_api_gateway_integration.node_lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  stage_name  = "stage-${terraform.workspace}"
}

# TODO: add CORS and OPTIONS method configuration

# TODO: not sure why we need a new "stage" since we got an API deployment above
# resource "aws_api_gateway_stage" "staging" {
#   deployment_id = aws_api_gateway_deployment.dev_deployment.id
#   rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
#   stage_name    = "staging"
# }

# resource "aws_api_gateway_method_settings" "settings" {
#   rest_api_id = aws_api_gateway_rest_api.serverless_api.id
#   stage_name  = aws_api_gateway_stage.staging.stage_name
#   method_path = "${aws_api_gateway_resource.resource.path_part}/${aws_api_gateway_method.method.http_method}"

#   settings {
#     # metrics_enabled = true
#     # logging_level   = "INFO"
#   }
# }

###############################
# STEP 4 - Static Website in S3
###############################

# The AWS S3 static website bucket with workspace/environment name appended
resource "aws_s3_bucket" "website_bucket" {
  depends_on    = [aws_api_gateway_deployment.dynamic_deployment]
  bucket        = "${var.bucket_prefix}-aws-serverless-app-${terraform.workspace}"
  acl           = "public-read"
  force_destroy = true
  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules  = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}