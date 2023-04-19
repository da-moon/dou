# Attach this IAM Policy to Roles:
resource "aws_iam_policy_attachment" "lambda_draining_permissions_attachment" {
  name = "${var.cluster_name}-lambda-draining-policy"

  roles      = [aws_iam_role.draining_lambda.name]
  policy_arn = aws_iam_policy.lambda_draining_permissions.arn

  depends_on = [aws_iam_policy.lambda_draining_permissions]
}

resource "aws_lambda_permission" "enable_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.draining_lambda.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.cluster_draining.arn
}

# IAM Policy Definition
resource "aws_iam_policy" "lambda_draining_permissions" {
  name = "${aws_sns_topic.cluster_draining.name}-drain-permissions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "ReceiveAndPublishMessageToTopic",
          "Effect": "Allow",
          "Action": [
                "autoscaling:CompleteLifecycleAction",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeHosts",
                "ecs:ListContainerInstances",
                "ecs:SubmitContainerStateChange",
                "ecs:SubmitTaskStateChange",
                "ecs:DescribeContainerInstances",
                "ecs:UpdateContainerInstancesState",
                "ecs:ListTasks",
                "ecs:DescribeTasks",
                "sns:Publish",
                "sns:ListSubscriptions"
          ],
          "Resource":"*"
      }
  ]
}
EOF

}

