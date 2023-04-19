data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_kms_key" "main" {
  description             = "KMS key for the ${var.env_name} environment"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow service-linked role use of the KMS",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow CloudTrail to encrypt logs and Describe Keys",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": [
              "kms:GenerateDataKey*",
              "kms:DescribeKey"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.trail_name}"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/${var.trail_name}"
                }
            }            
        },
        {
            "Sid": "Allow CloudWatch to access kms key",
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${data.aws_region.current.name}.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
            },
            "Action": "kms:CreateGrant",
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
EOF

  tags = {
    Name = "${var.env_name}-key"
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.env_name}-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "random_id" "secret_id" {
  byte_length = 4
}

resource "aws_secretsmanager_secret" "pem_file" {
  name        = "${var.env_name}-${random_id.secret_id.hex}-key.pem"
  kms_key_id  = aws_kms_key.main.id
  description = "Private SSH key for logging in to ${var.env_name} servers"

  recovery_window_in_days = 0

  tags = {
    Name = "${var.env_name}-${random_id.secret_id.hex}-key.pem"
  }
}

resource "aws_secretsmanager_secret_version" "pem_file" {
  secret_id     = aws_secretsmanager_secret.pem_file.id
  secret_string = tls_private_key.key.private_key_pem
}

