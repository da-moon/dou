# terraform-aws-s3-storage-bucket-spw

## Summary
Module for AWS s3 storage bucket

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-s3-storage-bucket-spw/tree/main.svg?style=svg&circle-token=c6d0a78ff51dc1c59624d23d8b1bee77062d0ba3)](https://circleci.com/gh/DigitalOnUs/terraform-aws-s3-storage-bucket-spw/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-s3-storage-bucket-spw?ref=0.0.1"
  
  name         = "terratest-storage-lqwkrcjxwvse"
  acl          = "private"
  versioning   = false
  replica_flag = false

  tags = {
    Application = "terratest-spw"
    Environment = "NonProd"
  }
}
```

**Example with replication block**

```terraform
module "module" {
  source = "github.com/DigitalOnUs/terraform-aws-s3-storage-bucket-spw?ref=0.0.1"
  
  name       = "terratest-storage-lqwkrcjxwvse"
  acl        = "private"
  versioning = true

  replication_configuration = {
    replica_id    = "terratest"
    status        = "Enabled"
    storage_class = "STANDARD"
  }

  ### replica configuration
  replica_flag       = true
  replica_name       = "terratest-storage-replica-lqwkrcjxwvse"
  replica_acl        = "private"
  replica_versioning = true

    bucket_replica_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "InternalReadAccess",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "s3:GetObject",
        "Resource": ["arn:aws:s3:::terratest-storage-replica-lqwkrcjxwvse/*"],
        "Condition": {
          "IpAddress": {
            "aws:SourceIp": [
              "10.103.0.0/16", "10.122.0.0/23", "10.122.0.0/23",
              "10.124.0.0/23", "10.155.1.0/24", "10.123.0.0/23" 
            ]
          }
        }     
      }
    ]
  }
  POLICY

  iam_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::terratest-storage-lqwkrcjxwvse"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::terratest-storage-lqwkrcjxwvse/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::terratest-storage-replica-lqwkrcjxwvse/*"
    }
  ]
}
POLICY

  iam_role = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

  tags = {
    Application = "terratest-spw"
    Environment = "NonProd"
  }
}
```

**Outputs**
| Name        | Description                |
|-------------|----------------------------|
| bucket_id | The name of the bucket |
| bucket_domain_name | The bucket domain name |
| bucket_arn | The ARN of the bucket |
| hosted_zone_id | The Route 53 Hosted Zone ID for this bucket's region. |
| bucket_region | The AWS region this bucket resides in. |
| replica_id | The name of the replica bucket. |
| replica_arn | The ARN of the replica bucket. |