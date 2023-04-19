# terraform-aws-s3-bucket-ssm

## Summary
Module for AWS s3 bucket

## Build status

[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-s3-bucket-ssm/tree/main.svg?style=svg&circle-token=afe0ae6305e45a53b5065962623dca6e9b5a0313)](https://circleci.com/gh/DigitalOnUs/terraform-aws-s3-bucket-ssm/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-s3-internal-web-bucket-ssm?ref=0.0.1"
  
  name   = "terratest"
  acl    = "private"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "InternalReadAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": ["arn:aws:s3:::terratest/*"],
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": ["10.101.0.0/16", "10.103.0.0/16", "10.122.0.0/23", "10.124.0.0/23", "10.155.1.0/24", "10.123.0.0/23"]
        }
      }
    }
  ]
}
POLICY

  versioning = true
  sse_algorithm = "AES256"

  website_configuration {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Application = "terratest-ssm"
    Environment = "NonProd"
  }
}
```

**Example with lifecycle rules**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-s3-internal-web-bucket-ssm?ref=0.0.1"
  
  name   = "terratest"
  acl    = "private"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "InternalReadAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": ["arn:aws:s3:::terratest/*"],
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": ["10.101.0.0/16", "10.103.0.0/16", "10.122.0.0/23", "10.124.0.0/23", "10.155.1.0/24", "10.123.0.0/23"]
        }
      }
    }
  ]
}
POLICY

  versioning = true
  sse_algorithm = "AES256"

  website_configuration {
    index_document = "index.html"
    error_document = "error.html"
  }

  lifecycle_rules = {
    "test" = {
      lifecycle_rule_prefix = "test/"
      enabled               = true
      transition = [{
        days          = 30
        storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
      }]
      expiration = null
      noncurrent_version_transition = [{
        days          = 30
        storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
      }]
      noncurrent_version_expiration = 90
    },
    "second_test" = {
      lifecycle_rule_prefix = "second_test/"
      enabled               = true
      transition = [{
        days          = 30
        storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
      }]
      expiration = 80
      noncurrent_version_transition = [{
        days          = 30
        storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
      }]
      noncurrent_version_expiration = 180
    }
  }

  tags = {
    Application = "terratest-ssm"
    Environment = "NonProd"
  }
}
```

**Outputs**
| Name        | Description                |
|-------------|----------------------------|
| bucket_id | The name of the bucket |
| bucket_arn | The ARN of the bucket |
| website_endpoint |The website endpoint of the bucket |
| bucket_domain_name | The bucket domain name |
| bucket_region | The AWS region this bucket resides in |
| hosted_zone_id | The Route 53 Hosted Zone ID for this bucket's region. |