# lambda function
module "lambda_function" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/lambda/s3_triggered_lambda?ref=0.0.127"
  lambda_count            = var.lambda_count
  lambda_bucket_id        = var.lambda_bucket_id
  lambda_s3_key           = var.lambda_s3_key
  lambda_function_name    = var.lambda_function_name
  file_name          = var.file_name
  lambda_iam_role             = var.lambda_iam_role
  runtime_env          = var.runtime_env # Update this if your code is written in nodejs or some other language.
  lambda_description      = var.lambda_description
  source_code_hash = var.source_code_hash
  timeout_sec          = var.timeout_sec
  memory_size      = var.memory_size
  subnet_ids = var.subnet_ids
  lambda_securitygroup = var.lambda_securitygroup
  lambda_vars = var.lambda_vars
  run_env = var.run_env
  s3_bucket_name = var.s3_bucket_name
  lambda_arn_push_es = var.lambda_arn_push_es
}

# S3 Event mapping to lambda
data "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = var.lambda_count
  bucket = data.aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_function_arn
    events              = split(",", var.s3_event_type)
    filter_prefix       = var.s3_key_prefix
    filter_suffix       = var.s3_file_suffix
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  count             = var.lambda_count
  name              = "/aws/lambda/${module.lambda_function.function_name}"
  retention_in_days = var.log_retain_days
}

#Subscribe lambda logs to invoke Lambda jobs which pushes to ES
resource "aws_lambda_permission" "cloudwatch_allow" {
  count               = var.lambda_count
  statement_id_prefix = "cloudwatch_to_es"
  action              = "lambda:InvokeFunction"
  function_name       = var.lambda_arn_push_es
  principal           = "logs.${var.default_region}.amazonaws.com"
  source_arn          = aws_cloudwatch_log_group.log_group[0].arn
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_logs_to_es" {
  count           = var.lambda_count
  depends_on      = [aws_lambda_permission.cloudwatch_allow]
  name            = "cloudwatch_logs_to_elasticsearch"
  log_group_name  = aws_cloudwatch_log_group.log_group[0].name
  filter_pattern  = ""
  destination_arn = var.lambda_arn_push_es
}
