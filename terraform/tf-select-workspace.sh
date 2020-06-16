#!/usr/bin/env bash

WORKSPACE_NAME=$1

if [ -z ${WORKSPACE_NAME} ]
then
    echo "Usage:"
    echo "$0 WORKSPACE_NAME"
    echo "Invalid parameters passed. Exiting."

    exit 1
fi

echo "Determining if ${WORKSPACE_NAME} workspace exists..."

if [ $(terraform workspace list | grep -c "${WORKSPACE_NAME}") -eq 0 ] ; then
  echo "Creating new ${WORKSPACE_NAME} workspace..."
  terraform workspace new "${WORKSPACE_NAME}" -no-color
else
  echo "Selecting existing ${WORKSPACE_NAME} workspace..."
  terraform workspace select "${WORKSPACE_NAME}" -no-color
fi
