#!/usr/bin/env bash

ENVIRONMENT_NAME=$1
TF_BACKEND_CONFIG_NAME=$2

if [ -z ${ENVIRONMENT_NAME} ] || [ -z ${TF_BACKEND_CONFIG_NAME} ]
then
    echo "Usage:"
    echo "$0 ENVIRONMENT_NAME TF_BACKEND_CONFIG_NAME DOTENV_FILE"
    echo "Invalid parameters passed. Exiting."

    exit 1
fi

terraform init -backend-config="${TF_BACKEND_CONFIG_NAME}"
sh tf-select-workspace.sh ${ENVIRONMENT_NAME}
terraform destroy -auto-approve
