#!/usr/bin/env bash

BUCKET_NAME=$1
API_URL=$2
DYNAMIC_ENV_NAME=$3

if [[ -z ${BUCKET_NAME} ]]; then
    echo "No bucket name passed in. Exiting."

    exit 1
fi

if [[ -z ${API_URL} ]]; then
    echo "No API URL passed in. Exiting."

    exit 1
fi

if [[ -z ${DYNAMIC_ENV_NAME} ]]; then
    echo "No dynamic environment name passed in. Exiting."

    exit 1
fi

echo "window._config = { apiUrl: '${API_URL}', envName: '${DYNAMIC_ENV_NAME}' };" > website/javascript/config.js

aws s3 cp website/ s3://${BUCKET_NAME}/ --recursive --acl public-read
