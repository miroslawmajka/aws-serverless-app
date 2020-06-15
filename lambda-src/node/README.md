# AWS Lambda Node Functions

To build the Lambda artifact:
```bash
cd lambda-src/node
./create-node-lambda-artifact.sh lambda-node-functions.zip
```

TODO:
* one entry file (index.js)
* multiple handlers exported with "handler" for "hello-node"
* handler for each functions