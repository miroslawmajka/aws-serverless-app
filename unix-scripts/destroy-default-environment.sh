#!/usr/bin/env bash

cd terraform

terraform init -backend-config="aws-s3-backend.tfconfig"
sh select-workspace.sh default
terraform destroy -auto-approve
