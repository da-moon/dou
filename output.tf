output "dynamo_name" {
  value = aws_dynamodb_table.source_table.*.id
}

output "dynamo_arn" {
  value = aws_dynamodb_table.source_table.*.id
}

output "dynamo_global_name" {
  value = element(concat(aws_dynamodb_global_table.global_table.*.id, [""]), 0)
}