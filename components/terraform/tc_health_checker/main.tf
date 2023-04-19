
data "aws_ssm_parameter" "repo_type" { name = "/teamcenter/shared/vcs/type" }
data "aws_ssm_parameter" "clone_url" { name = "/teamcenter/shared/vcs/clone_https_url" }
data "aws_ssm_parameter" "env_names" { name = "/teamcenter/shared/env_names" }

locals {
  prefix = var.installation_prefix != "" ? "${var.installation_prefix}-tc" : "tc"
}

data "aws_subnet" "main" {
  id = var.subnet_ids[0]
}

data "aws_vpc" "main" {
  id = data.aws_subnet.main.vpc_id
}

resource "aws_security_group" "health_checker" {
  name        = "${local.prefix}-health-checker"
  description = "Security group attached to health checker lambda function"
  vpc_id      = data.aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "archive_file" "health_checker_zip" {
  type        = "zip"
  output_path = "${path.module}/health_checker.zip"
  source_file = "${path.module}/health_checker.py"
}

resource "aws_lambda_function" "health_checker" {
  filename         = "${path.module}/health_checker.zip"
  function_name    = "${local.prefix}-health-checker"
  role             = aws_iam_role.health_checker_role.arn
  source_code_hash = data.archive_file.health_checker_zip.output_base64sha256
  runtime          = "python3.9"
  handler          = "health_checker.lambda_handler"
  timeout          = 50

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.health_checker.id]
  }
}

resource "aws_cloudwatch_event_rule" "every_minute" {
  name        = "${local.prefix}-health-checker-every-minute"
  description = "Trigger health check every minute"

  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "health_check_target" {
  for_each  = toset(split(",", nonsensitive(data.aws_ssm_parameter.env_names.value)))
  rule      = aws_cloudwatch_event_rule.every_minute.name
  target_id = "SendToLambda-${each.key}"
  arn       = aws_lambda_function.health_checker.arn
  input = <<DOC
{
  "env_name": "${each.key}",
  "repo_type": "${nonsensitive(data.aws_ssm_parameter.repo_type.value)}",
  "clone_url": "${nonsensitive(data.aws_ssm_parameter.clone_url.value)}"
}
DOC
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_checker.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}

