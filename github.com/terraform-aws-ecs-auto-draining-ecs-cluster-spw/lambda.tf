resource "aws_lambda_function" "draining_lambda" {
  s3_bucket     = var.lambda_bucket
  s3_key        = var.lambda_key
  function_name = "${var.cluster_name}-drainer"
  role          = aws_iam_role.draining_lambda.arn
  handler       = "index.lambda_handler"
  runtime       = "python2.7"
  timeout       = 300

  environment {
    variables = {
      run_env = var.run_env
    }
  }
}

resource "aws_iam_role" "draining_lambda" {
  name = "${var.cluster_name}-draining-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

}

