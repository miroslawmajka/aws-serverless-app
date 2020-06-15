#!/usr/bin/env bash

ARTIFACT_PATH=$1
DEPLOYMENT_BUCKET_NAME=$2
LAMBDA_NODE_FUNCTIONS_ZIP=$3

if [ -z ${ARTIFACT_PATH} ] || [ -z ${DEPLOYMENT_BUCKET_NAME} ] || [ -z ${LAMBDA_NODE_FUNCTIONS_ZIP} ]
then
    echo "Usage:"
    echo "$0 ARTIFACT_PATH DEPLOYMENT_BUCKET_NAME LAMBDA_NODE_FUNCTIONS_ZIP"
    echo "Invalid parameters passed. Exiting."

    exit 1
fi

echo "Uploading Node functions artifact to S3..."

aws s3 cp ${ARTIFACT_PATH} s3://${DEPLOYMENT_BUCKET_NAME}/${LAMBDA_NODE_FUNCTIONS_ZIP}