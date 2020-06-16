#!/usr/bin/env bash

ENVIRONMENT_NAME=default
LAMBDA_NODE_FUNCTIONS_ZIP=lambda-node-functions.zip

cd terraform

# TODO: move into separate script
terraform init -backend-config="aws-s3-backend.tfconfig"
terraform validate
sh select-workspace.sh ${ENVIRONMENT_NAME}
terraform plan -out ${ENVIRONMENT_NAME}.tfplan
terraform apply "${ENVIRONMENT_NAME}.tfplan"

WEBSITE_BUCKET_NAME=`terraform output website_bucket_name`
API_URL=`terraform output serverless_rest_api_base_url`
WEBSITE_URL=`terraform output website_url`
DEPLOYMENT_BUCKET_NAME=`terraform output deployment_bucket_name`
LAMBDA_NODE_HELLO_NAME=`terraform output lambda_node_hello_name`

cd -

sh unix-scripts/deploy-website.sh ${WEBSITE_BUCKET_NAME} ${API_URL} ${ENVIRONMENT_NAME}

cd lambda-src/node

sh create-node-lambda-artifact.sh ${LAMBDA_NODE_FUNCTIONS_ZIP}

cd -

cd unix-scripts

sh upload-lambda-artifact.sh ../lambda-src/node/${LAMBDA_NODE_FUNCTIONS_ZIP} ${DEPLOYMENT_BUCKET_NAME} ${LAMBDA_NODE_FUNCTIONS_ZIP}
sh deploy-lambda-artifact.sh ${LAMBDA_NODE_HELLO_NAME} ${DEPLOYMENT_BUCKET_NAME} ${LAMBDA_NODE_FUNCTIONS_ZIP}

cd -

echo ""
echo "AWS Serverless App is ready at ${WEBSITE_URL}"
