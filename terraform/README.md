# Infrastructure as Code (Terraform)

Cloud computing platforms such as AWS or Microsoft Azure give you a lot of flexibility when it comes to setting up your environments. The trouble with that is it becomes hard to maintain your infrastructure when it starts to outgrow its initial MVP stage.

Tools such as CloudFormation and Terraform greatly improve the processes that are required to keep the infrastructure up-to-date and grow it further.

This project is using Terraform to build the AWS services required for the application to run. These are:

-   S3
-   Lambda
-   API Gateway

## AWS

TODO

## Terraform

TODO

### Prerequisites

You need to install the latest Terraform command line tool. Please have a look at [Terraform Install](https://learn.hashicorp.com/tutorials/terraform/install-cli) for details regarding your development environment.

### Running Terraform

Make a copy of `aws-s3-backend.tfconfig.example` and name it `aws-s3-backend.tfconfig`.

Make a copy of `terraform.tfvars.example` and name it `terraform.tfvars`.

Change in the values in the new files to match your AWS setup and run the following commands to create the "ENV-NAME" (change the name) environment:

```bash
terraform init -backend-config="aws-s3-backend.tfconfig"
terraform workspace new ENV-NAME
terraform plan -out ENV-NAME.tfplan
terraform apply "ENV-NAME.tfplan"
```

Be careful when inventing the name of your environment. **S3** bucket names only accept alphanumeric characters and hyphens. The infrastructure set up in AWS gets its leading names from the terraform _workspace_ name!

This will create the environment giving you the S3 bucket URL to access the website.

To bring the environment down run the following command:

```bash
terraform destroy -auto-approve
terraform workspace select default
terraform workspace delete ENV-NAME
```

These will remove any resources created in AWS and alse remove the "ENV-NAME" workspace locally.
