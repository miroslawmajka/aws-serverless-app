#!/usr/bin/env bash

./node_modules/.bin/newman run postman_collection.json -e postman_environment.json -r cli,junit --reporter-junit-export $1
