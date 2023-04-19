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
  bucket_name = "terratest-${random_string.prefix.result}"
  tags = {
    Application = local.bucket_name
  }
}

module "module" {
  source = "../"

  name   = local.bucket_name
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
      "Resource": ["arn:aws:s3:::${local.bucket_name}/*"],
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": ["10.101.0.0/16", "10.103.0.0/16", "10.122.0.0/23", "10.124.0.0/23", "10.155.1.0/24", "10.123.0.0/23"]
        }
      }
    }
  ]
}
POLICY

  versioning    = true
  sse_algorithm = "AES256"

  website_configuration = {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = local.tags
}

output "bucket_id" {
  value = module.module.bucket_id
}

output "bucket_arn" {
  value = module.module.bucket_arn
}

output "website_endpoint" {
  value = module.module.website_endpoint
}

output "bucket_domain_name" {
  value = module.module.bucket_domain_name
}

output "bucket_region" {
  value = module.module.bucket_region
}