#!/usr/bin/env bash

ARTIFACT_NAME=$1

if [ -z ${ARTIFACT_NAME} ]
then
    echo "No artifact name passed in. Exiting."

    exit 1
fi

rm -rf node_modules
npm install --production

rm -rf ${ARTIFACT_NAME}
zip -rq ${ARTIFACT_NAME} index.js
zip -rq ${ARTIFACT_NAME} lib      

if [ -d "./node_modules" ] 
then
    zip -rq ${ARTIFACT_NAME} node_modules
fi
