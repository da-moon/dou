# terraform-aws-iam-role-ssm

## Summary
Module for AWS IAM account delegation role

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-iam-role-ssm/tree/main.svg?style=svg&circle-token=2a8ea488ad837d7eff67bd448476fb341c6be5ec)](https://circleci.com/gh/DigitalOnUs/terraform-aws-iam-role-ssm/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-iam-role-ssm?ref=0.0.1"
  
  name = "terratest-role-eixvtstksygs"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": { "AWS": "arn:aws:iam::237889007525:root" },
      "Effect": "Allow"
    }
  ]
}
POLICY

tags = {
    Application = "terratest-role-eixvtstksygs"
}
```

**Example with MFA**
```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-iam-role-ssm?ref=0.0.1"
  
  name = "terratest-role-eixvtstksygs"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": { "AWS": "arn:aws:iam::237889007525:root" },
            "Effect": "Allow",
            "Condition": {"Bool": {"aws:MultiFactorAuthPresent": "true" }}
        }
    ]
}
POLICY

tags = {
    Application = "terratest-role-eixvtstksygs"
}
```

**Outputs**
| Name        | Description                           |
|-------------|---------------------------------------|
| role_id     | The role's ID.                        |
| role_name   | The role's name.                      |
| arn         | The ARN assigned by AWS for this role |
| create_date | Creation date of the IAM role         |