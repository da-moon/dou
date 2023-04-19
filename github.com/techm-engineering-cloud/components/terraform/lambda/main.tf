resource "aws_iam_role" "lambda_role" {
  name = "${var.pipeline_name}-lambda"

  assume_role_policy = <<EOF
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

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.pipeline_name}-lambda"
  role = aws_iam_role.lambda_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowLogs",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowCodePipeline",
      "Effect": "Allow",
      "Action": [
        "codepipeline:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowSSM",
      "Effect": "Allow",
      "Action": [
        "ssm:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowS3",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.artifacts_bucket}",
        "arn:aws:s3:::${var.artifacts_bucket}/*"
      ],
      "Action": [
        "s3:*"
      ]
    }
  ]
}
EOF
}

resource "aws_lambda_function" "f" {
  filename         = var.code
  function_name    = var.function_name
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = var.code_hash
  runtime          = "python3.9"
  handler          = var.handler
  timeout          = 600
  environment {
    variables = var.env_vars
  }
}

