output "website_url" {
  value = "${aws_s3_bucket.website_bucket.website_endpoint}"
  description = "The AWS Serverless App website URL"
}

output "serverless_rest_api_base_url" {
  value = "${aws_api_gateway_deployment.dynamic_deployment.invoke_url}"
  description = "The AWS Serverless App REST API URL"
}