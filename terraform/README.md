# Using Terraform

Make a copy of `aws-s3-backend.tfconfig.example` and name it `aws-s3-backend.tfconfig`. 

Make a copy of `terraform.tfvars.example` and name it `terraform.tfvars`.

Change in the values in the new files to match your AWS setup and run the following commands to create the "ENV_NAME" (change the name) environment:

```
terraform init -backend-config="aws-s3-backend.tfconfig"
terraform workspace new ENV_NAME
terraform plan -out ENV_NAME.tfplan
terraform apply "ENV_NAME.tfplan"
```

This will create the environment giving you the S3 bucket URL to access the website.

To bring the environment down run the following command:
```
terraform destroy -auto-approve
terraform workspace select default
terraform workspace delete ENV_NAME
```

These will remove any resources created in AWS and alse remove the "ENV_NAME" workspace locally.