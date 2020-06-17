#!/usr/bin/env bash

ENVIRONMENT_NAME=$1
TF_BACKEND_CONFIG_NAME=$2
DOTENV_FILE=$3

if [ -z ${ENVIRONMENT_NAME} ] || [ -z ${TF_BACKEND_CONFIG_NAME} ] || [ -z ${DOTENV_FILE} ]
then
    echo "Usage:"
    echo "$0 ENVIRONMENT_NAME TF_BACKEND_CONFIG_NAME DOTENV_FILE"
    echo "Invalid parameters passed. Exiting."

    exit 1
fi

terraform init -backend-config="${TF_BACKEND_CONFIG_NAME}"
terraform validate
sh tf-select-workspace.sh ${ENVIRONMENT_NAME}
terraform plan -out ${ENVIRONMENT_NAME}.tfplan
terraform apply "${ENVIRONMENT_NAME}.tfplan"

echo WEBSITE_BUCKET_NAME=`terraform output website_bucket_name` > ${DOTENV_FILE}
echo WEBSITE_URL=`terraform output website_url` >> ${DOTENV_FILE}
echo API_URL=`terraform output serverless_rest_api_base_url` >> ${DOTENV_FILE}
echo DEPLOYMENT_BUCKET_NAME=`terraform output deployment_bucket_name` >> ${DOTENV_FILE}
echo LAMBDA_NODE_HELLO_NAME=`terraform output lambda_node_hello_name` >> ${DOTENV_FILE}
echo LAMBDA_NODE_LOTTERY_NAME=`terraform output lambda_node_lottery_name` >> ${DOTENV_FILE}
echo LAMBDA_PYTHON_HELLO_NAME=`terraform output lambda_python_hello_name` >> ${DOTENV_FILE}
