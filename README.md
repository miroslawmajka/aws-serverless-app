# AWS Serverless App

This is an end-to-end pipeline solution for an AWS S3 static website with serverless Lambda backend in Node and Python, Terraform IaC and deployment pipelines in Azure DevOps.

Using the [W3 Schools](https://www.w3schools.com/w3css/w3css_templates.asp) template for a basic website. As their site mentions "You are free to modify, save, share, and use them in all your projects."

## README Contents

* [Azure DevOps Pipelines](pipelines/README.md)
* [Node Lambda Functions](lambda-src/node/README.md)
* [Python Lambda Functions](lambda-src/python/README.md)
* [Terraform IaC](terraform/README.md)
* [API Tests](api-tests/README.md)
* [Selenium UI Tests](ui-tests/selenium/README.md)
* [Cypress UI Tests](ui-tests/cypress/README.md)

## Setting up the default environment

Run:
```bash
./unix-scripts/setup-default-environment.sh
```

This will deploy the application to AWS and return the URL at which you can access the website.

## Bringing the default environment down

Run:
```bash
./unix-scripts/destroy-default-environment.sh
```

This command will remove all AWS resources from the **default** Terraform workspace.

## CORS

CORS is not a big problem within the dynamic environment as both the S3 static website and the Lambda functions exposed via API Gateway run off
the Amazon main domain.

When developing the project into a proper-hosted domain (e.g. "https://www.myawesomewebsite.com/) then CORS would need to be addressed as the website
will be running in its own domain and the API Gateway resources will be running in a separate one. Additional Terraform resources will need to be added for that.

Testing CORS with jQuery in the website:
```javascript
$.get(`${_config.apiUrl}/hello-node`, data => console.log(data));
$.get(`${_config.apiUrl}/hello-python`, data => console.log(data));
```
