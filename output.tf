output "lambda_function_arn" {
  value = element(concat(aws_lambda_function.lambda_function.*.arn, [""]), 0)
}

output "function_name" {
  value = aws_lambda_function.lambda_function.0.function_name
}

output "lambda_function_invoke_arn" {
  value = element(concat(aws_lambda_function.lambda_function.*.invoke_arn, [""]), 0)
}

output "lambda_function_qualified_arn" {
  value = element(concat(aws_lambda_function.lambda_function.*.qualified_arn, [""]), 0)
}
