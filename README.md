# terraform-aws-iam-policy-ssm

## Summary
This generates a policy for *account A* so that users in *account A* are allowed to assume roles in *account B*.

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-iam-policy-ssm/tree/main.svg?style=svg&circle-token=f4269a92aa3045d37367c103f6e909e32a59c815)](https://circleci.com/gh/DigitalOnUs/terraform-aws-iam-policy-ssm/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-iam-policy-ssm?ref=0.0.1"
  
  role_name = "terratest-role-eixvtstksygs"
  description = "Policy created by Terratest"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": [
      "arn:aws:iam::658620301396:role/terratest-role-eixvtstksygs"
    ]
  }
}
POLICY

  tags = {
    Application = "terratest-spw"
    Account     = "658620301396"
  }
}
```

**Outputs**
| Name   | Description                             |
|--------|-----------------------------------------|
| id     | The policy's ID.                        |
| arn    | The ARN assigned by AWS to this policy. |
| name   | The name of the policy.                 |
| path   | The path of the policy in IAM.          |
| policy | The policy document.                    |