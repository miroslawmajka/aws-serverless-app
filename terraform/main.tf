provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Terraform backend for storing state will be in S3 but povided in a separate "tfconfig" file
terraform {
  backend "s3" {}
}

###############################
# STEP 1 - static website in S3
###############################

# The AWS S3 static website bucket with workspace/environment name appended
resource "aws_s3_bucket" "website_bucket" {
  bucket        = "${var.bucket_prefix}-aws-serverless-app-${terraform.workspace}"
  force_destroy = true
}

resource "aws_s3_bucket" "lambda_deployments_bucket" {
  bucket        = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  force_destroy = true
}

# TODO: use terraform random provider to randomize the bucket name as they need to be globally unique

# TODO: make the bucket a "static website" that can serve content publicly

# TODO: return URL from terraform so it can be accessed by automated UI tests in a step down the line

###########################
# STEP 2 - Lambda functions
###########################

data "archive_file" "lambda_dummy_node_zip" {
  type        = "zip"
  output_path = "/tmp/lambda_dummy_node.zip"
  source {
    content  = file("dummy-lambda/node/index.js")
    filename = "index.js"
  }
}

data "archive_file" "lambda_dummy_python_zip" {
  type        = "zip"
  output_path = "/tmp/lambda_dummy_python.zip"
  source {
    content  = file("dummy-lambda/python/main.py")
    filename = "main.py"
  }
}

resource "aws_s3_bucket_object" "lambda_dummy_node_object" {
  bucket     = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  key        = "lambda_dummy_node.zip"
  source     = "/tmp/lambda_dummy_node.zip"
  depends_on = [data.archive_file.lambda_dummy_node_zip, aws_s3_bucket.lambda_deployments_bucket]
}

resource "aws_s3_bucket_object" "lambda_dummy_python_object" {
  bucket     = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  key        = "lambda_dummy_python.zip"
  source     = "/tmp/lambda_dummy_python.zip"
  depends_on = [data.archive_file.lambda_dummy_python_zip, aws_s3_bucket.lambda_deployments_bucket]
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "lambdaRole-${terraform.workspace}"
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

resource "aws_lambda_function" "lambda_dummy_node_function" {
  function_name = "aws-serverless-app-${terraform.workspace}-node-function"
  runtime       = "nodejs12.x"
  handler       = "index.handler"
  role          = aws_iam_role.iam_for_lambda.arn
  s3_bucket     = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  s3_key        = "lambda_dummy_node.zip"
  depends_on    = [aws_s3_bucket_object.lambda_dummy_node_object]
}

resource "aws_lambda_function" "lambda_dummy_python_function" {
  function_name = "aws-serverless-app-${terraform.workspace}-python-function"
  runtime       = "python3.8"
  handler       = "main.handler"
  role          = aws_iam_role.iam_for_lambda.arn
  s3_bucket     = "${var.bucket_prefix}-deployments-${terraform.workspace}"
  s3_key        = "lambda_dummy_python.zip"
  depends_on    = [aws_s3_bucket_object.lambda_dummy_python_object]
}

######################
# STEP 3 - API Gateway
######################

# TODO: crete endpoints that point to Lambda functions

# TODO: CORS for the website to use the gateway functions

# TODO: figure out authorization

