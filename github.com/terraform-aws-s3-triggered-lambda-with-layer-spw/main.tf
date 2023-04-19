# lambda function
module "lambda_function" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/lambda/lambda_basic_with_layer?ref=1.0.37"
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
  lambdalayers_arn           = split(",", var.lambdalayers_arn)
}

# S3 Event mapping to lambda
data "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_lambda_permission" "s3" {
  count               = var.lambda_count
  statement_id_prefix = "${var.run_env}-AllowExecutionFromS3"
  action              = "lambda:InvokeFunction"
  function_name       = module.lambda_function.lambda_function_arn
  principal           = "s3.amazonaws.com"
  source_arn          = data.aws_s3_bucket.bucket.arn
}
