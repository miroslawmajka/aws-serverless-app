# Infrastructure as Code (Terraform)

## AWS

TODO

## Terraform

TODO

### Prerequisites

TODO

### Running Terraform

Make a copy of `aws-s3-backend.tfconfig.example` and name it `aws-s3-backend.tfconfig`.

Make a copy of `terraform.tfvars.example` and name it `terraform.tfvars`.

Change in the values in the new files to match your AWS setup and run the following commands to create the "yourenvname" (change the name) environment:

```bash
terraform init -backend-config="aws-s3-backend.tfconfig"
terraform workspace new yourenvname
terraform plan -out yourenvname.tfplan
terraform apply "yourenvname.tfplan"
```

This will create the environment giving you the S3 bucket URL to access the website.

To bring the environment down run the following command:

```bash
terraform destroy -auto-approve
terraform workspace select default
terraform workspace delete yourenvname
```

These will remove any resources created in AWS and alse remove the "yourenvname" workspace locally.
