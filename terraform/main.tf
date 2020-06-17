provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Terraform backend for storing state will be in S3 but povided in a separate "tfconfig" file
terraform {
  backend "s3" {}
}

locals {
  lambda_deployment_bucket_name     = "${var.app_prefix}-lambda-deployment-${terraform.workspace}"
  lambda_node_hello_function_name   = "${var.app_prefix}-node-hello-${terraform.workspace}"
  lambda_node_lottery_function_name = "${var.app_prefix}-node-lottery-${terraform.workspace}"
  lambde_python_hello_function_name = "${var.app_prefix}-python-hello-${terraform.workspace}"
  dummy_lambda_path                 = "${path.root}/dummy-lambda"
  dummy_node_temp_file_path         = "/tmp/lambda-node-dummy.zip"
  dummy_python_temp_file_path       = "/tmp/lambda-python-dummy.zip"
  dummy_node_s3_key                 = "lambda-node-dummy-functions.zip"
  dummy_python_s3_key               = "lambda-python-dummy-functions.zip"
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
  name               = "${var.app_prefix}-lambda-role-${terraform.workspace}"
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

# TODO: use maps for runtime variables
module "lambda_node_hello" {
  source                           = "./modules/lambda"
  lambda_role_arn                  = aws_iam_role.lambda_exec_role.arn
  lambda_name                      = local.lambda_node_hello_function_name
  handler                          = "index.helloHandler"
  runtime                          = "nodejs12.x"
  dummy_artifact_directory         = "${local.dummy_lambda_path}/node"
  dummy_artifact_handler_file_name = "index.js"
  dummy_temp_file_path             = local.dummy_node_temp_file_path
  s3_key                           = local.dummy_node_s3_key
  s3_bucket                        = local.lambda_deployment_bucket_name
  s3_bucket_depends_on             = [aws_s3_bucket.lambda_deployments_bucket]
  lambda_role_depends_on           = [aws_iam_role.lambda_exec_role]
}

# TODO: use maps for runtime variables
module "lambda_node_lottery" {
  source                           = "./modules/lambda"
  lambda_role_arn                  = aws_iam_role.lambda_exec_role.arn
  lambda_name                      = local.lambda_node_lottery_function_name
  handler                          = "index.lotteryHandler"
  runtime                          = "nodejs12.x"
  dummy_artifact_directory         = "${local.dummy_lambda_path}/node"
  dummy_artifact_handler_file_name = "index.js"
  dummy_temp_file_path             = local.dummy_node_temp_file_path
  s3_key                           = local.dummy_node_s3_key
  s3_bucket                        = local.lambda_deployment_bucket_name
  s3_bucket_depends_on             = [aws_s3_bucket.lambda_deployments_bucket]
  lambda_role_depends_on           = [aws_iam_role.lambda_exec_role]
}

# TODO: use maps for runtime variables
module "lambda_python_hello" {
  source                           = "./modules/lambda"
  lambda_role_arn                  = aws_iam_role.lambda_exec_role.arn
  lambda_name                      = local.lambde_python_hello_function_name
  handler                          = "main.helloHandler"
  runtime                          = "python3.8"
  dummy_artifact_directory         = "${local.dummy_lambda_path}/python"
  dummy_artifact_handler_file_name = "main.py"
  dummy_temp_file_path             = local.dummy_python_temp_file_path
  s3_key                           = local.dummy_python_s3_key
  s3_bucket                        = local.lambda_deployment_bucket_name
  s3_bucket_depends_on             = [aws_s3_bucket.lambda_deployments_bucket]
  lambda_role_depends_on           = [aws_iam_role.lambda_exec_role]
}

###################################
# STEP 3 - API Gateway Integrations
###################################

resource "aws_api_gateway_rest_api" "serverless_api" {
  name        = "aws-serverless-app-rest-api-${terraform.workspace}"
  description = "REST API for the ${terraform.workspace} environment"
  depends_on  = [module.lambda_node_hello, module.lambda_python_hello]
}

module "api_gateway_node_hello_integration" {
  source            = "./modules/api-gateway"
  lambda_name       = local.lambda_node_hello_function_name
  lambda_invoke_arn = module.lambda_node_hello.function_invoke_arn
  rest_api          = aws_api_gateway_rest_api.serverless_api
  top_api_path      = "hello-node"
  verb              = "GET"
}

module "api_gateway_node_lottery_integration" {
  source            = "./modules/api-gateway"
  lambda_name       = local.lambda_node_lottery_function_name
  lambda_invoke_arn = module.lambda_node_lottery.function_invoke_arn
  rest_api          = aws_api_gateway_rest_api.serverless_api
  top_api_path      = "lottery-node"
  verb              = "GET"
}

module "api_gateway_python_hello_integration" {
  source            = "./modules/api-gateway"
  lambda_name       = local.lambde_python_hello_function_name
  lambda_invoke_arn = module.lambda_python_hello.function_invoke_arn
  rest_api          = aws_api_gateway_rest_api.serverless_api
  top_api_path      = "hello-python"
  verb              = "GET"
}

resource "aws_api_gateway_deployment" "dynamic_api_stage_deployment" {
  stage_name  = "stage-${terraform.workspace}"
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  depends_on  = [module.api_gateway_python_hello_integration, module.api_gateway_node_hello_integration]

  # The calculated SHA1 forces the API redeployment if changes to any integrations are detected
  # See https://www.terraform.io/docs/providers/aws/r/api_gateway_deployment.html for details
  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(module.api_gateway_node_hello_integration.lambda_integration),
      jsonencode(module.api_gateway_node_lottery_integration.lambda_integration),
      jsonencode(module.api_gateway_python_hello_integration.lambda_integration)
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}

###################################
# STEP 4 - S3 Static Website Bucket
###################################

resource "aws_s3_bucket" "website_bucket" {
  bucket        = "${var.app_prefix}-aws-serverless-app-${terraform.workspace}"
  force_destroy = true
  acl           = "public-read"
  depends_on    = [aws_api_gateway_deployment.dynamic_api_stage_deployment]
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
