resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket      = var.bucket_name
  eventbridge = var.eventbridge

  dynamic "lambda_function" {
    for_each = var.lambda_function
    content {
      events              = lambda_function.value.events
      filter_prefix       = lookup(lambda_function.value, "filter_prefix", null)
      filter_suffix       = lookup(lambda_function.value, "filter_suffix", null)
      id                  = lookup(lambda_function.value, "id", null)
      lambda_function_arn = lambda_function.value.lambda_function_arn
    }
  }

  dynamic "queue" {
    for_each = var.queue
    content {
      events        = queue.value.events
      filter_prefix = lookup(queue.value, "filter_prefix", null)
      filter_suffix = lookup(queue.value, "filter_suffix", null)
      id            = lookup(queue.value, "id", null)
      queue_arn     = queue.value.queue_arn
    }
  }

  dynamic "topic" {
    for_each = var.topic
    content {
      events        = topic.value.events
      filter_prefix = lookup(topic.value, "filter_prefix", null)
      filter_suffix = lookup(topic.value, "filter_suffix", null)
      id            = lookup(topic.value, "id", null)
      topic_arn     = topic.value.topic_arn
    }
  }
}