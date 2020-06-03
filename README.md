# AWS Serverless App

This is a boilerplate project for an AWS S3 static website with serverless Lambda backend in Node and Python, Terraform IaC and deployment pipelines in Azure DevOps.

Using the [W3 Schools](https://www.w3schools.com/w3css/w3css_templates.asp) template for a basic website. As their site mentions "You are free to modify, save, share, and use them in all your projects."

## README Contents

* [Azure DevOps Pipelines](pipelines/README.md)
* [Node Lambda Functions](lambda-src/node/README.md)
* [Python Lambda Functions](lambda-src/python/README.md)
* [Terraform IaC](terraform/README.md)
* [API Tests](api-tests/README.md)
* [Selenium UI Tests](ui-tests/selenium/README.md)
* [Cypress UI Tests](ui-tests/cypress/README.md)

# CORS

Testing CORS with jQuery in the website:
```javascript
$.get(`${_config.apiUrl}/hello-node`, data => console.log(data));
$.get(`${_config.apiUrl}/hello-python`, data => console.log(data));
```
