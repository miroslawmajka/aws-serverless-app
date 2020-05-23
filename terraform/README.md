# Using Terraform

Make a copy of `aws-s3-backend.tfconfig.example` and name it `aws-s3-backend.tfconfig`. 

Make a copy of `terraform.tfvars.example` and name it `terraform.tfvars`.

Fill in the values in the new files and run the following commands to create the "poc" (proof of concept) environment:

```
terraform init -backend-config="aws-s3-backend.tfconfig"
terraform workspace new poc
terraform plan -out poc.tfplan
terraform apply "poc.tfplan"
```

This will create the environment giving you the S3 bucket URL to access the website.

To bring the environment down run the following command:
```
terraform destroy -auto-approve
terraform workspace select default
terraform workspace delete poc
```

These will remove any resources created in AWS and alse remove the "poc" workspace locally.