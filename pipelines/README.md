# Azure DevOps Pipelines

The project is configured to but used with Microsoft Azure DevOps Pipelines. The YAML files in this directory describe the CI/CD pipelines in code.

![Pipeline Run](../docs/pipeline-run.png)

## Pipeline Status

| Environment                                                                                    | Build Status                                                                                                                                                                                                                                                      |
| ---------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Default](http://miroslawmajka-aws-serverless-app-default.s3-website-eu-west-1.amazonaws.com/) | [![Build Status](https://dev.azure.com/miroslawmajka/aws-serverless-app/_apis/build/status/miroslawmajka.aws-serverless-app.production?branchName=master)](https://dev.azure.com/miroslawmajka/aws-serverless-app/_build/latest?definitionId=2&branchName=master) |
| Dynamic                                                                                        | [![Build Status](https://dev.azure.com/miroslawmajka/aws-serverless-app/_apis/build/status/miroslawmajka.aws-serverless-app.ci?branchName=master)](https://dev.azure.com/miroslawmajka/aws-serverless-app/_build/latest?definitionId=1&branchName=master)         |

## Bash Scripts

The pipelines are constructed using Bash scripts called from **tasks**.
When there are multiple commands within one script task it is sometimes necessary to check check the for the exit codes to mark the **task** as failed:
```bash
sh script-one.sh

if [[ $? != 0 ]]; then exit 1; fi

sh script-two.sh

if [[ $? != 0 ]]; then exit 1; fi

copy file1.txt file2.txt

sh script-three.sh
```

Notice that after the last shell script call there is no `if` statement. The last command exit code gets passed on to the DevOps **task** and the result can be evaluated. Howver in the case of `script-one.sh` and `script-two.sh` any potential failed commands causing these scripts to return other exit codes than "0" would NOT cause the the **task** to fail as these calls are NOT the last command in the script outline.

Please see the actual example below from the `job-deploy-lambda-python-functions.yml` file:
```yaml
- script: |
    source $(TF_ARTIFACT_PATH)/$(TF_OUTPUT_VARS)

    sh upload-lambda-artifact.sh $(LAMBDA_PYTHON_FUNCTIONS_ZIP_PATH) $DEPLOYMENT_BUCKET_NAME $(LAMBDA_PYTHON_FUNCTIONS_ZIP)
    
    if [[ $? != 0 ]]; then exit 1; fi
    
    sh deploy-lambda-artifact.sh $LAMBDA_PYTHON_HELLO_NAME $DEPLOYMENT_BUCKET_NAME $(LAMBDA_PYTHON_FUNCTIONS_ZIP)
displayName: Update Python Lambda functions
```

## Setup Steps

Install Terraform from Azure DevOps Marketplace:

```
A task is missing. The pipeline references a task called 'terraformInstaller'. This usually indicates the task isn't installed, and you may be able to install it from the Marketplace: https://marketplace.visualstudio.com. (Task version 0, job 'TerraformApply', step ''.)
A task is missing. The pipeline references a task called 'terraformInstaller'. This usually indicates the task isn't installed, and you may be able to install it from the Marketplace: https://marketplace.visualstudio.com. (Task version 0, job 'TerraformDestroy', step ''.)
```

## Sensitive Files

Put AWS credentials in the library

Permit pipeline access to sensitive files

Warning about incurring costs from AWS / Azure DevOps
