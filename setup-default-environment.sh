#!/usr/bin/env bash

cd terraform

terraform init -backend-config="aws-s3-backend.tfconfig"
terraform validate
sh select-workspace.sh default
terraform plan -out default.tfplan
terraform apply "default.tfplan"

BUCKET_NAME=`terraform output website_bucket_name`
API_URL=`terraform output serverless_rest_api_base_url`
WEBSITE_URL=`terraform output website_url`

cd -

sh deploy-website.sh ${BUCKET_NAME} ${API_URL} default

echo
echo "AWS Serverless App is ready at ${WEBSITE_URL}
