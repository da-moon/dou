resource "aws_kms_key" "my_kms_key" {
  description               = "Enable IAM User Permissions"
  customer_master_key_spec  = "SYMMETRIC_DEFAULT"
  is_enabled                = true

  tags = {
    Project     = var.project_name
    Environment = var.run_env
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::237889007525:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF
}