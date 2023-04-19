# lambda function
resource "aws_lambda_function" "lambda_function" {
  count            = var.lambda_count
  s3_bucket        = var.lambda_bucket_id
  s3_key           = var.lambda_s3_key
  function_name    = var.lambda_function_name
  handler          = var.file_name
  role             = var.lambda_iam_role
  runtime          = var.runtime_env # Update this if your code is written in nodejs or some other language.
  description      = var.lambda_description
  source_code_hash = var.source_code_hash
  timeout          = var.timeout_sec
  memory_size      = var.memory_size
  layers           = var.lambdalayers_arn
  vpc_config {
    subnet_ids         = split(",", var.subnet_ids)
    security_group_ids = split(",", var.lambda_securitygroup)
  }
  environment {
    variables = var.lambda_vars
  }
}
