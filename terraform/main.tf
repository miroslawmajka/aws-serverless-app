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
  bucket = "${var.bucket_prefix}-aws-serverless-app-${terraform.workspace}"
}

resource "aws_s3_bucket" "lambda_deployments_bucket" {
  bucket = "${var.bucket_prefix}-deployments-${terraform.workspace}"
}

# TODO: use terraform random provider to randomize the bucket name as they need to be globally unique

# TODO: make the bucket a "static website" that can serve content publicly

# TODO: return URL from terraform so it can be accessed by automated UI tests in a step down the line


###########################
# STEP 2 - Lambda functions
###########################

# TODO: create the Node function(s)

# TODO: create the Python function(s)


######################
# STEP 3 - API Gateway
######################

# TODO: crete endpoints that point to Lambda functions

# TODO: CORS for the website to use the gateway functions

# TODO: figure out authorization


#########################
# STEP 4 - Cognito
#########################

# TODO: create user pool and save details for one user