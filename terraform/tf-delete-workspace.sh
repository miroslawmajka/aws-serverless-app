#!/usr/bin/env bash

ENVIRONMENT_NAME=$1

if [ -z ${ENVIRONMENT_NAME} ]
then
    echo "Usage:"
    echo "$0 ENVIRONMENT_NAME TF_BACKEND_CONFIG_NAME DOTENV_FILE"
    echo "Invalid parameters passed. Exiting."

    exit 1
fi

terraform workspace select default
terraform workspace delete ${ENVIRONMENT_NAME}
