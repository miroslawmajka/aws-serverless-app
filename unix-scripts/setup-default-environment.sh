#!/usr/bin/env bash

ENVIRONMENT_NAME=default
DOTENV_FILE=.env
LAMBDA_NODE_FUNCTIONS_ZIP=lambda-node-functions.zip

cd terraform

sh tf-apply.sh ${ENVIRONMENT_NAME} aws-s3-backend.tfconfig ${DOTENV_FILE}

source ${DOTENV_FILE}

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
