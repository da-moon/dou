provider "aws" {
  region = "us-west-2"
}

resource "random_string" "prefix" {
  length  = 12
  upper   = false
  number  = false
  special = false
}

locals {
  bucket_name  = "terratest-storage-${random_string.prefix.result}"
  replica_name = "terratest-replica-storage-${random_string.prefix.result}"
  tags = {
    Application = local.bucket_name
  }
}

module "module" {
  source = "../"

  name       = local.bucket_name
  acl        = "private"
  versioning = true

  replication_configuration = {
    replica_id    = "terratest"
    status        = "Enabled"
    storage_class = "STANDARD"
  }

  ### replica configuration
  replica_flag       = true
  replica_name       = local.replica_name
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
      "Resource": ["arn:aws:s3:::${local.replica_name}/*"],
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
        "arn:aws:s3:::${local.bucket_name}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${local.bucket_name}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.replica_name}/*"
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

  tags = local.tags
}

output "bucket_id" {
  value = module.module.bucket_id
}

output "bucket_domain_name" {
  value = module.module.bucket_domain_name
}

output "bucket_arn" {
  value = module.module.bucket_arn
}

output "bucket_region" {
  value = module.module.bucket_region
}

output "hosted_zone_id" {
  value = module.module.hosted_zone_id
}

output "replica_id" {
  value = module.module.replica_id
}

output "replica_arn" {
  value = module.module.replica_arn
}