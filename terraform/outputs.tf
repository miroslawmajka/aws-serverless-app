output "website_url" {
  value = "http://${aws_s3_bucket.website_bucket.website_endpoint}"
  description = "The AWS Serverless App website URL"
}

output "serverless_rest_api_base_url" {
  value = "${aws_api_gateway_deployment.dynamic_deployment.invoke_url}"
  description = "The AWS Serverless App REST API URL"
}

output "website_bucket_name" {
  value = "${aws_s3_bucket.website_bucket.bucket}"
  description = "The AWS Serverless App website bucket name"
}

output "deployment_bucket_name" {
  value = "${aws_s3_bucket.lambda_deployments_bucket.bucket}"
  description = "The AWS Serverless App deployment bucket name"
}

output "lambda_node_name" {
  value = "${aws_lambda_function.lambda_node_function.function_name}"
  description = "The AWS Serverless App Node Lambda function name"
}

output "lambda_python_name" {
  value = "${aws_lambda_function.lambda_python_function.function_name}"
  description = "The AWS Serverless App Python Lambda function name"
}
