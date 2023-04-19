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

  #depends_on    = ["aws_iam_role.lambda_iam_role","data.archive_file.es_clean"]
  vpc_config {
    subnet_ids         = split(",", var.subnet_ids)
    security_group_ids = split(",", var.lambda_securitygroup)
  }
  environment {
    variables = var.lambda_vars
  }
}

# SNS Event mapping to lambda
resource "aws_sns_topic" "lambda_sns_topic" {
  count = var.lambda_count
  name  = var.sns_topic
}

resource "aws_lambda_permission" "sns" {
  count               = var.lambda_count
  statement_id_prefix = "${var.run_env}-AllowExecutionFromSNS"
  action              = "lambda:InvokeFunction"
  function_name       = aws_lambda_function.lambda_function[0].function_name
  principal           = "sns.amazonaws.com"
  source_arn          = aws_sns_topic.lambda_sns_topic[0].arn
}

resource "aws_sns_topic_subscription" "lambda" {
  count     = var.lambda_count
  topic_arn = aws_sns_topic.lambda_sns_topic[0].arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_function[0].arn
}

resource "aws_cloudwatch_log_group" "log_group" {
  count             = var.lambda_count
  name              = "/aws/lambda/${aws_lambda_function.lambda_function[0].function_name}"
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
