# terraform-aws-iam-user-ssm

## Summary
Module for AWS IAM user with keys

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-iam-user-ssm/tree/main.svg?style=svg&circle-token=bd437d8d2a47800f14237af0dcdfcfa95b9f8cb4)](https://circleci.com/gh/DigitalOnUs/terraform-aws-iam-user-ssm/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-iam-user-ssm?ref=0.0.1"
  
  user_name    = "terratest-user-eixvtstksygs"
  path         = "/"
  user_destroy = false
  key_status   = "Active"

  tags = {
    Application = "terratest-user-eixvtstksygs"
  }
}
```

**Outputs**
| Name             | Description                           |
|------------------|---------------------------------------|
| user_name        | The user's ID.                        |
| arn              | The ARN assigned by AWS for this user |
| encrypted_secret | Encrypted secret, base64 encoded      |
| access_key       | Access key ID                         |
| secret           | Secret access key.                    |