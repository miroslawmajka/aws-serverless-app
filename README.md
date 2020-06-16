# AWS Serverless App

![Pipeline Logo](docs/pipeline-logo.png)

This is an end-to-end pipeline solution for an AWS S3 static website with serverless Lambda backend in Node and Python, Terraform IaC and deployment pipelines in Azure DevOps.

Using the [W3 Schools](https://www.w3schools.com/w3css/w3css_templates.asp) template for a basic website. As their site mentions "You are free to modify, save, share, and use them in all your projects."

## README Contents

-   [Azure DevOps Pipelines](pipelines/README.md)
-   [Terraform IaC](terraform/README.md)
-   [Lambda Functions](lambda-src/README.md)
-   [API Tests](api-tests/README.md)
-   [UI Tests](ui-tests/README.md)

## Setting up the default environment

Run:

```bash
sh setup-default-environment.sh
```

This will deploy the application to AWS and return the URL at which you can access the website.

## Bringing the default environment down

Run:

```bash
sh destroy-default-environment.sh
```

This command will remove all AWS resources from the **default** Terraform workspace.

## Website CORS

CORS is not a big problem within the dynamic environment as both the S3 static website and the Lambda functions exposed via API Gateway run off
the Amazon main domain.

When developing the project into a proper-hosted domain (e.g. "https://www.myawesomewebsite.com/) then CORS would need to be addressed as the website
will be running in its own domain and the API Gateway resources will be running in a separate one. Additional Terraform resources will need to be added for that.

Testing CORS with jQuery in the website using Chrome developer tools:

```javascript
$.get(`${_config.apiUrl}/hello-node`, data => console.log(data));
$.get(`${_config.apiUrl}/hello-python`, data => console.log(data));
```
