resource "aws_iam_role" "eda-master-ec2-role" {
  name = "${var.iam_role}-master"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "master_eda-iam-role"
  }
}

resource "aws_iam_role" "eda-server-ec2-role" {
  name = "${var.iam_role}-server"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "server_eda-iam-role"
  }
}

resource "aws_iam_instance_profile" "eda-ec2-role-master" {
  name = "${var.iam_instance_profile}-master"
  role = aws_iam_role.eda-master-ec2-role.name
}

resource "aws_iam_instance_profile" "eda-ec2-role-server" {
  name = "${var.iam_instance_profile}-server"
  role = aws_iam_role.eda-server-ec2-role.name
}


resource "aws_iam_role_policy" "master-ec2-role-policy" {
  name = "${var.iam_role_policy}-master"
  role = aws_iam_role.eda-master-ec2-role.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource =  [
            "arn:aws:s3:::${var.bucket}",
            "arn:aws:s3:::${var.bucket}/*",
            "arn:aws:s3:::eda-ibm-lsf-installers",
            "arn:aws:s3:::eda-ibm-lsf-installers/*"
        ]
      },
      {
        Action = [
          "ec2:TerminateInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeKeyPairs",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "ec2:ModifyIdFormat",
          "ec2:AssociateIamInstanceProfile",
          "ec2:ReplaceIamInstanceProfileAssociation",
          "ec2:CancelSpotFleetRequests",
          "ec2:DescribeSpotFleetInstances",
          "ec2:DescribeSpotFleetRequests",
          "ec2:DescribeSpotFleetRequestHistory",
          "ec2:ModifySpotFleetRequest",
          "ec2:RequestSpotFleet",
          "ec2:DescribeSpotInstanceRequests",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetLaunchTemplateData",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:DeleteLaunchTemplateVersions",
          "iam:PassRole",
          "iam:ListRoles",
          "iam:ListInstanceProfiles",
          "iam:CreateServiceLinkedRole"
        ]
        Effect   = "Allow"
        Resource =  [
            "*"
        ]
      },
      {
        Effect   = "Allow",
        Action = "S3:ListAllMyBuckets",
        Resource = "arn:aws:s3:::*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "server-ec2-role-policy" {
  name = "${var.iam_role_policy}-server"
  role = aws_iam_role.eda-server-ec2-role.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource =  [
            "arn:aws:s3:::${var.bucket}",
            "arn:aws:s3:::${var.bucket}/*",
            "arn:aws:s3:::eda-ibm-lsf-installers",
            "arn:aws:s3:::eda-ibm-lsf-installers/*"
        ]
      },
      {
        Effect   = "Allow",
        Action = "S3:ListAllMyBuckets",
        Resource = "arn:aws:s3:::*"
      },
    ]
  })
}