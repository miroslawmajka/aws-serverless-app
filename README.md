# AWS Serverless App Pipeline

![Project Logo](docs/project-logo.png)

**TABLE OF CONTENTS**

- [AWS Serverless App Pipeline](#aws-serverless-app-pipeline)
  - [Introduction](#introduction)
    - [What is this project?](#what-is-this-project)
    - [What is this project NOT?](#what-is-this-project-not)
    - [READMEs](#readmes)
    - [AWS](#aws)
    - [Azure DevOps](#azure-devops)
  - [Accounts and Secrets](#accounts-and-secrets)
  - [Default Environment](#default-environment)
    - [Setting up the default AWS environment](#setting-up-the-default-aws-environment)
    - [Bringing the default AWS environment down](#bringing-the-default-aws-environment-down)
  - [Application Website](#application-website)
    - [CORS](#cors)
  - [Open Source](#open-source)

## Introduction

This is an end-to-end pipeline solution for an AWS S3 static website with serverless Lambda backend in Node and Python, Terraform IaC and deployment pipelines in Azure DevOps.

The author does not take any responsibility for any issues resulting from using this software. Please see the [LICENCE](LICENSE) file for details.

This project has been inspired by the [AWS Serverless Web App Tutorial](https://aws.amazon.com/getting-started/hands-on/build-serverless-web-app-lambda-apigateway-s3-dynamodb-cognito/).

### What is this project?

This project repository is about building a reliable build, testing and deployment pipeline for a serverless AWS-specific Web environment.

This is all about integrating various complementary technologies to deliver a solution that:

-   takes code in git
-   runs unit tests against it
-   builds artifacts
-   creates a serverless Web environment in a well-known Cloud provider space
-   deploys the code to that environment
-   runs tests against that application
-   collects the results
-   brings that environment down keeping the costs low
-   most of all, it is about running a Web application _CHEAPLY_ when utilising the _serverless_ methodology (no constantly running EC2s or VMs)

Apart from that the solution provides a pipeline for a constantly active (i.e. "production") environment in the Cloud.

![hosting](docs/hosting.jpg)

### What is this project NOT?

You may be surprised to see that some of the components here are too simplistic. The actual Web application is NOT the main focus here:

-   this is not a brilliant Web application
-   this is not a complete Web API
-   this is not an automated browser testing project (see [cucumber-boilerplate](https://github.com/miroslawmajka/cucumber-boilerplate) for that)
-   this is not a comprehensive AWS Lambda / API Gateway guide
-   this is not a Terraform guide

If you are looking for advice on the latest and most fashionable Web libraries or frameworks then this is not the right repository.

![obi-wan](docs/not-the-project.jpg)

### READMEs

For information about specific parts of this project please read the relevant README files:

-   [Azure DevOps Pipelines README](pipelines/README.md)
-   [Infrastructure as Code (Terraform) README](terraform/README.md)
-   [Lambda Functions README](lambda-src/README.md)
-   [API Tests README](api-tests/README.md)
-   [UI Tests README](ui-tests/README.md)

### AWS

The **AWS** cloud hosting platform is in the title of this project so to run this project yourself you will need an active [Amazon Web Services](https://aws.amazon.com/) account. One of the main goals of this project is to build a reliable deployment pipeline that will support an AWS-based Web application cheaply. That means looking out for what comes for FREE from Amazon.

S3 static website buckets an Lambda functions are some of the features that AWS gives you as part of the FREE tier (as of August 2020). If carefully put things together you can use this project as a template for building a dynamic full stack Web application with authentcation and DB support (not covered in this project but well described in the [AWS Serverless Web App Tutorial](https://aws.amazon.com/getting-started/hands-on/build-serverless-web-app-lambda-apigateway-s3-dynamodb-cognito/)).

### Azure DevOps

I've been working with many CI/CD platforms before, including Jenkins, TeamCity, Bitbucket Pipelins, CircleCI. However [Azure DevOps](https://dev.azure.com/) has proven very reliable in the last year. You can run jobs in cloud-hosted agents as well as locally configured ones which can give you more features need for a given task. The YAML-based setup is easy to understand and gives you plenty of flexibility when it comes to constructing pipelines.

Azure DevOps is the the preferred build, test and deployment pipeline tool for this project.

## Accounts and Secrets

Please make sure you keep your AWS key and secret information secure. Running the pipelines in Azure DevOps requires an active AWS account with a CLI key. Please make sure you store these details securely and never reveal them as this might result in your AWS accoutn becoming compromised.

**YOU HAVE BEEN WARNED**

Make sure you know what you are doing as setting up this pipeline against an active AWS account and deploying the sample application might result in additional costs on your credit cart.

## Default Environment

You can setup the default environment locally for the AWS serverless application using a handy setup script in the top directory of this repository.

Please make sure you have the **Terraform** prerequisites installed and setup. The details are available in the [Terraform README](terraform/README.md).

### Setting up the default AWS environment

Run:

```bash
sh setup-default-environment.sh
```

This will deploy the application to AWS and return the URL at which you can access the website.

### Bringing the default AWS environment down

Run:

```bash
sh destroy-default-environment.sh
```

This command will remove all AWS resources from the **default** Terraform workspace.

## Application Website

Using the [W3 Schools](https://www.w3schools.com/w3css/w3css_templates.asp) template for a basic website. As their site mentions "You are free to modify, save, share, and use them in all your projects."

### CORS

CORS is not a big problem within the dynamic environment as both the S3 static website and the Lambda functions exposed via API Gateway run off
the Amazon main domain.

When developing the project into a proper-hosted domain (e.g. "https://www.myawesomewebsite.com/") then CORS would need to be addressed as the website
will be running in its own domain and the API Gateway resources will be running in a separate one. Additional Terraform resources will need to be added for that.

Testing CORS with jQuery in the website using **Chrome Developer Tools**:

```javascript
$.get(`${_config.apiUrl}/hello-node`, data => console.log(data));
```

If the call fails then there is an issue with CORS that needs addressing in AWS API Gateway.

## Open Source

This is an **Open Source** project and it will evolving. The README files in teh subdirectories need more TLC. The inline comments can be better at explaining what is meant to be going on at what stage. Feel free to raise issue, fork, create pull requests if you think something can be improved.
