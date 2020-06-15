#!/usr/bin/env bash

ENVIRONMENT_NAME=default

cd terraform

terraform init -backend-config="aws-s3-backend.tfconfig"
terraform validate
sh select-workspace.sh ${ENVIRONMENT_NAME}
terraform plan -out ${ENVIRONMENT_NAME}.tfplan
terraform apply "${ENVIRONMENT_NAME}.tfplan"

WEBSITE_BUCKET_NAME=`terraform output website_bucket_name`
API_URL=`terraform output serverless_rest_api_base_url`
WEBSITE_URL=`terraform output website_url`

cd -

sh unix-scripts/deploy-website.sh ${WEBSITE_BUCKET_NAME} ${API_URL} ${ENVIRONMENT_NAME}

cd lambda-src/node
../../unix-scripts/create-node-lambda-artifact.sh lambda-node-functions.zip

echo "TODO: deploy lambda functions"

cd -

echo ""
echo "AWS Serverless App is ready at ${WEBSITE_URL}"
