provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Terraform backend for storing state will be in S3 but povided in a separate "tfconfig" file
terraform {
  backend "s3" {}
}

# The AWS S3 static website bucket with workspace/environment name appended
resource "aws_s3_bucket" "website-bucket" {
  bucket = "aws-serverless-app-${terraform.workspace}"
}

# TODO: make the bucket a "static website" that can serve content publicly
