
data "aws_kms_key" "key" {
  key_id = var.kms_key_id
}

resource "aws_iam_role" "deployment_center" {
  name = "${local.prefix}-deployment-center"

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

resource "aws_iam_instance_profile" "deployment_center" {
  name = "${local.prefix}-deployment-center"
  role = aws_iam_role.deployment_center.name
}

resource "aws_iam_role_policy" "deployment_center" {
  name = "${local.prefix}-deployment-center-main"
  role = aws_iam_role.deployment_center.id

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
                "s3:CreateJob",
                "s3:ListBucket",
                "s3:GetObject",
                "s3:GetBucketLocation",
                "s3:GetObjectAcl",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.artifacts_bucket_name}"
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.artifacts_bucket_name}/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "deployment_center_ssm" {
  role       = aws_iam_role.deployment_center.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "deployment_center_cw" {
  role       = aws_iam_role.deployment_center.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy" "deployment_center_kms" {
  name = "${local.prefix}-deployment-center-kms"
  role = aws_iam_role.deployment_center.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:Encrypt",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
        "kms:CreateGrant"
      ],
      "Resource": "${data.aws_kms_key.key.arn}"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:ListSecrets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "deployment_center_dns" {
  name = "${local.prefix}-deployment-center-dns"
  role = aws_iam_role.deployment_center.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": "${data.aws_route53_zone.private.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "deployment_center_ecr" {
  name = "${local.prefix}-deployment-center-ecr"
  role = aws_iam_role.deployment_center.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "ecr:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "deployment_center_eks" {
  name = "${local.prefix}-deployment-center-eks"
  role = aws_iam_role.deployment_center.id

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

resource "aws_kms_grant" "deployment_center" {
  name              = "${local.prefix}-deployment-center"
  key_id            = var.kms_key_id
  grantee_principal = aws_iam_role.deployment_center.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

