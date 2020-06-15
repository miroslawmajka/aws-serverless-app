#!/usr/bin/env bash

WEBSITE_BUCKET_NAME=$1
API_URL=$2
ENVIRONMENT_NAME=$3

if [ -z ${WEBSITE_BUCKET_NAME} ] || [ -z ${API_URL} ] || [ -z ${ENVIRONMENT_NAME} ]
then
    echo "Usage:"
    echo "$0 WEBSITE_BUCKET_NAME API_URL ENVIRONMENT_NAME"
    echo "Invalid parameters passed. Exiting."

    exit 1
fi

echo "Deploying AWS Serverless App website component..."

echo "window._config = { apiUrl: '${API_URL}', envName: '${ENVIRONMENT_NAME}' };" > website/javascript/config.js

aws s3 cp website/ s3://${WEBSITE_BUCKET_NAME}/ --recursive --acl public-read
