# lambda function
resource "aws_lambda_function" "lambda_function" {
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
  layers           = split(",", var.lambdalayers_arn)

  vpc_config {
    subnet_ids         = split(",", var.subnet_ids)
    security_group_ids = [var.lambda_securitygroup]
  }
  environment {
    variables = var.lambda_vars
  }
}

# workaround code to create the event pattern JSON
locals {
  event_pattern = {
    source      = ["aws.autoscaling"]
    detail-type = var.detail_type
    detail = {
      AutoScalingGroupName = var.asg_name
    }
  }
}
# cloudwatch event fo lambda

resource "aws_cloudwatch_event_rule" "asg_event" {
  name          = var.schedule_name
  description   = "Capture ASG events"
  event_pattern = jsonencode(local.event_pattern)

  #   event_pattern = <<PATTERN
  #   {
  #     "source": [
  #       "aws.autoscaling"
  #     ],
  #     "detail-type": [for type in var.detail_type : type],
  #     "detail": {
  #       "AutoScalingGroupName": [for asg in var.asg_name : asg]
  #     }
  #   }
  # PATTERN
}

resource "aws_cloudwatch_event_target" "target_lambda" {
  arn        = aws_lambda_function.lambda_function.arn
  rule       = aws_cloudwatch_event_rule.asg_event.name
  depends_on = [aws_lambda_function.lambda_function]
}

resource "aws_lambda_permission" "event_trigger_lambda_function" {
  statement_id_prefix = var.run_env
  action              = "lambda:InvokeFunction"
  function_name       = aws_lambda_function.lambda_function.function_name
  principal           = "events.amazonaws.com"
  source_arn          = aws_cloudwatch_event_rule.asg_event.arn
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.log_retain_days
}

#Subscribe lambda logs to invoke Lambda jobs which pushes to ES
resource "aws_lambda_permission" "cloudwatch_allow" {
  statement_id_prefix = "cloudwatch_to_es"
  action              = "lambda:InvokeFunction"
  function_name       = var.lambda_arn_push_es
  principal           = "logs.${var.default_region}.amazonaws.com"
  source_arn          = aws_cloudwatch_log_group.log_group.arn
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_logs_to_es" {
  depends_on      = [aws_lambda_permission.cloudwatch_allow]
  name            = "cloudwatch_logs_to_elasticsearch"
  log_group_name  = aws_cloudwatch_log_group.log_group.name
  filter_pattern  = ""
  destination_arn = var.lambda_arn_push_es
}
