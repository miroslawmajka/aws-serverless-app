#!/usr/bin/env bash

LAMBDA_NAME=$1
DEPLOYMENT_BUCKET_NAME=$2
LAMBDA_NODE_FUNCTIONS_ZIP=$3

if [ -z ${LAMBDA_NAME} ] || [ -z ${DEPLOYMENT_BUCKET_NAME} ] || [ -z ${LAMBDA_NODE_FUNCTIONS_ZIP} ]
then
    echo "Usage:"
    echo "$0 LAMBDA_NAME DEPLOYMENT_BUCKET_NAME LAMBDA_NODE_FUNCTIONS_ZIP"
    echo "Invalid parameters passed. Exiting."

    exit 1
fi

echo "Updating ${LAMBDA_NAME} Lambda function..."

aws lambda update-function-code --function-name ${LAMBDA_NAME} --s3-bucket ${DEPLOYMENT_BUCKET_NAME} --s3-key ${LAMBDA_NODE_FUNCTIONS_ZIP}