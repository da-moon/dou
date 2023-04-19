resource "aws_sns_topic" "cluster_draining" {
  name = "${var.cluster_name}-draining"
}

resource "aws_sns_topic_subscription" "cluster_draining_subscription" {
  topic_arn = aws_sns_topic.cluster_draining.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.draining_lambda.arn
}

