##IAM role
resource "aws_iam_role" "tc_server_role" {
  name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-role" : "tc-${var.env_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com" , "eks.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

##Instance profile
resource "aws_iam_instance_profile" "tc_instance_profile" {
  name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-profile" : "tc-${var.env_name}-profile"
  role = aws_iam_role.tc_server_role.name
}

##iam policy
resource "aws_iam_role_policy" "tc_s3_policy" {
  name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-servers-policy" : "tc-${var.env_name}-servers-policy"
  role = aws_iam_role.tc_server_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListStorageLensConfigurations",
                "s3:ListAccessPointsForObjectLambda",
                "s3:GetAccessPoint",
                "s3:PutAccountPublicAccessBlock",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListAccessPoints",
                "s3:PutAccessPointPublicAccessBlock",
                "s3:ListJobs",
                "s3:PutStorageLensConfiguration",
                "s3:ListMultiRegionAccessPoints",
                "s3:CreateJob"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.artifacts_bucket_name}"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.artifacts_bucket_name}/*"
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ecr",
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "logs",
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": "arn:aws:route53:::hostedzone/${jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id}"
        },
        {
             "Sid": "VisualEditor5",
             "Effect": "Allow",
             "Action": [
                  "kms:Decrypt",
                  "kms:ReEncrypt*",
                  "kms:Encrypt",
                  "kms:GenerateDataKey*",
                  "kms:DescribeKey",
                  "kms:CreateGrant"
              ],
              "Resource": "${jsondecode(data.aws_s3_object.core_outputs.body).kms_key_arn}"
         }

      ]
}
EOF
}

resource "aws_iam_role_policy" "eks_policy" {
  name = "${var.env_name}-server-eks"
  role = aws_iam_role.tc_server_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "eks:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

##SSM policy attachment
resource "aws_iam_role_policy_attachment" "server_ssm" {
  role       = aws_iam_role.tc_server_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

##cloud watc h policy attachment
resource "aws_iam_role_policy_attachment" "server_cloud_watch" {
  role       = aws_iam_role.tc_server_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

##Access to kms key
resource "aws_kms_grant" "main" {
  name              = "my-grant"
  key_id            = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id
  grantee_principal = aws_iam_role.tc_server_role.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}
