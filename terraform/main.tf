provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Terraform backend for storing state will be in S3 but povided in a separate "tfconfig" file
terraform {
  backend "s3" {}
}

locals {
  lambda_deployment_bucket_name = "${var.bucket_prefix}-lambda-deployment-${terraform.workspace}"
  dummy_lambda_path             = "${path.root}/dummy-lambda"
}

######################################
# STEP 1 - S3 Lambda Deployment Bucket
######################################

resource "aws_s3_bucket" "lambda_deployments_bucket" {
  bucket        = local.lambda_deployment_bucket_name
  force_destroy = true
}

###########################
# STEP 2 - Lambda Functions
###########################

resource "aws_iam_role" "lambda_exec_role" {
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

module "lambda_node_hello" {
  source                           = "./modules/lambda"
  lambda_role_arn                  = aws_iam_role.lambda_exec_role.arn
  lambda_name                      = "aws-serverless-app-node-function-${terraform.workspace}"
  handler                          = "index.handler"
  runtime                          = "nodejs12.x"
  dummy_artifact_directory         = "${local.dummy_lambda_path}/node"
  dummy_artifact_handler_file_name = "index.js"
  dummy_temp_file_path             = "/tmp/lambda-node-dummy.zip"
  s3_key                           = "lambda-node-functions.zip"
  s3_bucket                        = local.lambda_deployment_bucket_name
  s3_bucket_depends_on             = [aws_s3_bucket.lambda_deployments_bucket]
  lambda_role_depends_on           = [aws_iam_role.lambda_exec_role]
}

module "lambda_python_hello" {
  source                           = "./modules/lambda"
  lambda_role_arn                  = aws_iam_role.lambda_exec_role.arn
  lambda_name                      = "aws-serverless-app-python-function-${terraform.workspace}"
  handler                          = "main.handler"
  runtime                          = "python3.8"
  dummy_artifact_directory         = "${local.dummy_lambda_path}/python"
  dummy_artifact_handler_file_name = "main.py"
  dummy_temp_file_path             = "/tmp/lambda-python-dummy.zip"
  s3_key                           = "lambda-python-functions.zip"
  s3_bucket                        = local.lambda_deployment_bucket_name
  s3_bucket_depends_on             = [aws_s3_bucket.lambda_deployments_bucket]
  lambda_role_depends_on           = [aws_iam_role.lambda_exec_role]
}

######################
# STEP 3 - API Gateway
######################

resource "aws_api_gateway_rest_api" "serverless_api" {
  name        = "aws-serverless-app-rest-api-${terraform.workspace}"
  description = "REST API for the ${terraform.workspace} environment"
  depends_on  = [module.lambda_node_hello, module.lambda_python_hello]
}

resource "aws_api_gateway_resource" "resource_hello_node" {
  path_part   = "hello-node"
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
}

resource "aws_api_gateway_method" "method_node" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.resource_hello_node.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_node_hello_integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.resource_hello_node.id
  http_method             = aws_api_gateway_method.method_node.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_node_hello.function_invoke_arn
}

resource "aws_lambda_permission" "apigw_node_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_node_hello.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_resource" "resource_hello_python" {
  path_part   = "hello-python"
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
}

resource "aws_api_gateway_method" "method_python" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.resource_hello_python.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_python_hello_integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.resource_hello_python.id
  http_method             = aws_api_gateway_method.method_python.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_python_hello.function_invoke_arn
}

resource "aws_lambda_permission" "apigw_python_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_python_hello.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_deployment" "dynamic_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_python_hello_integration, aws_api_gateway_integration.lambda_node_hello_integration]
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  stage_name  = "stage-${terraform.workspace}"
}

# TODO: add CORS and OPTIONS method configuration for production deployment

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
