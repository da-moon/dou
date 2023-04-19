###############
#  S3 Bucket  #
###############
module "bucket" {
  source  = "app.terraform.io/DoU-TFE/s3-bucket-ssm/aws"
  version = "0.0.2"

  name       = var.name
  acl        = var.acl
  versioning = var.versioning

  sse_algorithm     = var.sse_algorithm
  kms_master_key_id = var.kms_master_key_id
  policy            = var.policy

  replication_configuration = {
    iam_role_arn       = var.replica_flag != false ? module.role[0].arn : null
    replica_id         = var.replication_configuration.replica_id
    status             = var.replication_configuration.status
    storage_class      = var.replication_configuration.storage_class
    replica_bucket_arn = var.replica_flag != false ? module.replica[0].bucket_arn : null
  }

  tags = var.tags

  depends_on = [module.replica]
}

##########################
#  S3 Bucket replication #
##########################
module "replica" {
  source  = "app.terraform.io/DoU-TFE/s3-bucket-ssm/aws"
  version = "0.0.2"

  count = var.replica_flag != false ? 1 : 0

  name       = var.replica_name
  acl        = var.replica_acl
  versioning = var.replica_versioning

  policy = var.bucket_replica_policy

  tags = var.tags
}

module "role" {
  source  = "app.terraform.io/DoU-TFE/iam-role-ssm/aws"
  version = "0.0.3"

  count = var.replica_flag != false ? 1 : 0

  name   = "${var.name}-role"
  policy = var.iam_role
}

module "policy" {
  source  = "app.terraform.io/DoU-TFE/iam-policy-ssm/aws"
  version = "0.0.2"

  count = var.replica_flag != false ? 1 : 0

  role_name = "${var.name}-policy"
  policy    = var.iam_policy

  depends_on = [module.replica, module.bucket]
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  count = var.replica_flag != false ? 1 : 0

  role       = module.role[0].role_name
  policy_arn = module.policy[0].arn
}