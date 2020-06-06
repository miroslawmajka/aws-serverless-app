variable "lambda_name" {}
variable "runtime" {}
variable "handler" {}
variable "lambda_role_arn" {}
variable "dummy_artifact_directory" {}
variable "dummy_artifact_handler_file_name" {}
variable "dummy_temp_file_path" {}
variable "s3_bucket" {}
variable "s3_key" {}

variable "s3_bucket_depends_on" {
  type    = any
  default = []
}

variable "lambda_role_depends_on" {
  type    = any
  default = []
}