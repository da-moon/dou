# terraform-aws-iam-group-ssm

## Summary
Module for AWS IAM group

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-iam-group-ssm/tree/main.svg?style=svg&circle-token=f4269a92aa3045d37367c103f6e909e32a59c815)](https://circleci.com/gh/DigitalOnUs/terraform-aws-iam-group-ssm/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-iam-group-ssm?ref=0.0.1"
  
  name = "terratest-group-eixvtstksygs"
  path = "/"

  users = ["237889007525"]
}
```

**Outputs**
| Name       | Description                            |
|------------|----------------------------------------|
| group_id   | The group's ID.                        |
| group_name | The group's name.                      |
| arn        | The ARN assigned by AWS for this group |
| users      | List of IAM User names                 |