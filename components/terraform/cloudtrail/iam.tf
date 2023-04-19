data "aws_caller_identity" "current" {}

# CloudTrail - CloudWatch
#
# This section is used for allowing CloudTrail to send logs to CloudWatch.
#

# This policy allows the CloudTrail service for any account to assume this role.
data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

# This role is used by CloudTrail to send logs to CloudWatch.
resource "aws_iam_role" "cloudtrail_roles" {
  name               = "${var.env_name}-cloudtrail-role"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json
}

resource "aws_iam_policy" "cloudtrail-policy" {
  name        = "${var.env_name}-cloudtrail-policy"
  description = "policy for trail to send events to cloudwatch log groups"
  policy      = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
              "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
              "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
            ]
        }
      ]
    }
  EOF
}

resource "aws_iam_policy_attachment" "cloudtrail-roles-policies" {
  name       = "${var.env_name}-cloudtrail-role-policy-attachment"
  policy_arn = aws_iam_policy.cloudtrail-policy.arn
  roles      = [aws_iam_role.cloudtrail_roles.name]
}


##Assign policy document to s3 policy
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.trail-bucket.id

  policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "*",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.trail-bucket.id}"
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.trail-bucket.id}/*",
        "Condition": {
          "StringEquals": {
            "s3:x-amz-acl": "bucket-owner-full-control"
          }
        }
      }
    ]
  }
  POLICY
}