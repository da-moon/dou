locals {
  name = "armory-lambda"
  tags = {
    Owner     = "armory.ps@digitalonus.com"
    Terraform = true
  }
}

// Allows for things like CloudWatch logging and metrics.
data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Create a bucket to store the lambdas
resource "aws_s3_bucket" "spinnaker_lambdas" {
  bucket = "dou-armory-spinnaker-lambdas"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    name        = "dou-armory-spinnaker-lambdas"
  }
}

// Gives our Lambda permission to assume roles and attach the execution role.
resource "aws_iam_role" "iam_for_lambda" {
  depends_on = [data.aws_iam_policy.AWSLambdaBasicExecutionRole]
  name                = "ps_lambda_execution_role"
  managed_policy_arns = [data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn]
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// policy that defines permissions for the lambda.
resource "aws_iam_policy" "logging_policy" {
  name = "ps_lambda_logging_policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

// attach the policy to role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.logging_policy.arn
}

resource "aws_cloudwatch_log_group" "ps_lambda_log_group" {
  name              = "/aws/lambda/ps_lambda_log_group"
  retention_in_days = 30
}
