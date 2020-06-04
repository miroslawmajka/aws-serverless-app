#!/usr/bin/env bash

TEST_RESULTS=$1

if [[ -z ${TEST_RESULTS} ]]; then
    echo "No test results location name passed in. Exiting."

    exit 1
fi

./node_modules/.bin/newman run postman_collection.json -e postman_environment.json -r cli,junit --reporter-junit-export ${TEST_RESULTS}
