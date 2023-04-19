# terraform-aws-s3-bucket-notification-ssm

## Summary
You can use the Amazon S3 Event Notifications feature to receive notifications when certain events happen in your S3 bucket. You store this configuration in the notification subresource that's associated with a bucket.
Amazon S3 can send event notification messages to the following destinations:

* Amazon Simple Notification Service (Amazon SNS) topics
* Amazon Simple Queue Service (Amazon SQS) queues
* AWS Lambda function

## Build status
[![CircleCI](https://circleci.com/gh/DigitalOnUs/terraform-aws-s3-bucket-notification-ssm/tree/main.svg?style=svg&circle-token=6f45a3b7bca7e1fe7e352acec3ae6839149500fd)](https://circleci.com/gh/DigitalOnUs/terraform-aws-s3-bucket-notification-ssm/tree/main)

## Getting Started

**Example**

```terraform
module "module" {
  source  = "app.terraform.io/DoU-TFE/s3-bucket-notification-ssm/aws"
  version = "x.x.x"
  
  bucket_name = data.aws_s3_bucket.bucket.id

  topic = [{
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }]
}
```

**Multiple configurations**

```terraform
module "module" {
  source  = "app.terraform.io/DoU-TFE/s3-bucket-notification-ssm/aws"
  version = "x.x.x"
  
  bucket_name = data.aws_s3_bucket.bucket.id

  topic = [{
    topic_arn     = aws_sns_topic.topic[0].arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "MyLogs/"
    filter_suffix = ".log"
  },
  {
    topic_arn     = aws_sns_topic.topic[1].arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "OtherLogs/"
    filter_suffix = ".log"
  }]
}
```

**Outputs**
| Name               | Description                        |
|--------------------|------------------------------------|
| s3_notification_id | The ID of the bucket notification. |