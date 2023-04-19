# Role to to give the ASG permissions to post to this SNS topic
resource "aws_iam_role" "draining_asg_role" {
  name = "${var.cluster_name}-draining-asg-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

}

# Attach this IAM Policy to Roles:
resource "aws_iam_policy_attachment" "sns_push_policy_attachment" {
  name = "${var.cluster_name}-push-policy-attachment"

  roles = [aws_iam_role.draining_lambda.name, aws_iam_role.draining_asg_role.name]
  policy_arn = aws_iam_policy.sns_push_policy.arn

  depends_on = [aws_iam_policy.sns_push_policy]
}

# IAM Policy Definition
resource "aws_iam_policy" "sns_push_policy" {
  name = "${aws_sns_topic.cluster_draining.name}-pubsub"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "ReceiveAndPublishMessageToTopic",
          "Effect": "Allow",
          "Action": [
              "sns:Unsubscribe",
              "sns:Publish",
              "sns:Subscribe"
          ],
          "Resource":"arn:aws:sns:${var.default_region}:${data.aws_caller_identity.current.account_id}:${aws_sns_topic.cluster_draining.name}"
      }
  ]
}
EOF

}

