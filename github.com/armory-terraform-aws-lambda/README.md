# armory-terraform-aws-lambda

This repo contains the terraform scripts for building and maintaining an AWS Lambda Function to use in development.

## Deploying

Lambda infrastructure is managed via Terraform in the `main.tf` file. This script doesn't create any Lambda resources, just IAM roles to allow a function to execute and the s3 bucket to store it.

You'll need `dev` AWS credentials to apply and update the stack.

# Resources

|Name|Type|
|-|-|
|[aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)|resource|
|[aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)|resource|
|[aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)|resource|
|[aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)|resource|
|[aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)|resource|

# Inputs

|Name|Description|Type|Default|Required|
|----|-----------|----|-------|--------|
|region|AWS Region to deploy to|`string`|`us-west-2`|yes|
