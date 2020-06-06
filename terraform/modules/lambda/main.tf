data "archive_file" "lambda_dummy_zip" {
  type        = "zip"
  output_path = var.dummy_temp_file_path
  source {
    content  = file("${var.dummy_artifact_directory}/${var.dummy_artifact_handler_file_name}")
    filename = var.dummy_artifact_handler_file_name
  }
}

resource "aws_s3_bucket_object" "lambda_dummy_s3_object" {
  bucket     = var.s3_bucket
  key        = var.s3_key
  source     = var.dummy_temp_file_path
  depends_on = [data.archive_file.lambda_dummy_zip,var.s3_bucket_depends_on]
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_name
  runtime       = var.runtime
  handler       = var.handler
  role          = var.lambda_role_arn
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  depends_on    = [aws_s3_bucket_object.lambda_dummy_s3_object,var.lambda_role_depends_on]
}