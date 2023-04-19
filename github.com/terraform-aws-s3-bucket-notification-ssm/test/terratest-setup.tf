provider "aws" {
  region = "ca-central-1"
}

resource "random_string" "prefix" {
  length  = 8
  upper   = false
  number  = false
  special = false
}

locals {
  name = "s3-notification-${random_string.prefix.result}"
  tags = {
    Name        = local.name
    Application = "terraform-aws-s3-notification-ssm"
    Environment = "terratest"
  }
}

data "aws_region" "current" {}

module "s3_bucket_ssm" {
  source  = "app.terraform.io/DoU-TFE/s3-bucket-ssm/aws"
  version = "0.0.3"

  name = local.name
  tags = local.tags
}

resource "aws_sns_topic" "topic" {
  name = "${local.name}-topic"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
      "Effect": "Allow",
      "Principal": { "Service": "s3.amazonaws.com" },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:*:*:${local.name}-topic",
      "Condition":{
          "ArnLike":{"aws:SourceArn":"${module.s3_bucket_ssm.bucket_arn}"}
      }
  }]
}
POLICY
}

module "module" {
  source = "../"

  bucket_name = module.s3_bucket_ssm.bucket_id

  topic = [{
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "MyLogs/"
    filter_suffix = ".log"
  }]
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "id" {
  value = module.module.s3_notification_id
}

output "sns_arn" {
  value = aws_sns_topic.topic.arn
}