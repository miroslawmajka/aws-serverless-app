#!/usr/bin/env bash

TEST_RESULTS=$1

if [ -z ${TEST_RESULTS} ]
then
    echo "Usage:"
    echo "$0 TEST_RESULTS"
    echo "Invalid parameters passed. Exiting."

    exit 1
fi

./node_modules/.bin/newman run postman_collection.json -e postman_environment.json -r cli,junit --reporter-junit-export ${TEST_RESULTS}
