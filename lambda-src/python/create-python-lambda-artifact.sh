#!/usr/bin/env bash

ARTIFACT_NAME=$1

if [ -z ${ARTIFACT_NAME} ]
then
    echo "No artifact name passed in. Exiting."

    exit 1
fi

rm -rf ${ARTIFACT_NAME}
zip -rq ${ARTIFACT_NAME} main.py
