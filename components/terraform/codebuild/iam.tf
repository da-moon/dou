
resource "aws_iam_role" "service_role" {
  name = var.prefix_name != "" ? "${var.prefix_name}-codebuild-servicerole" : "codebuild-servicerole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["codebuild.amazonaws.com", "eks.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    tag-key = var.prefix_name != "" ? "${var.prefix_name}-codebuild-servicerole" : "codebuild-servicerole"
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = var.prefix_name != "" ? "${var.prefix_name}-codebuild-policy" : "codebuild-policy"
  role = aws_iam_role.service_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:*"
      ]
    },
    {
      "Effect": "Allow", 
      "Action": [
        "ec2:*"
      ],
      "Resource": "*" 
    },
    {
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.artifacts_bucket}",
        "arn:aws:s3:::${var.artifacts_bucket}/*"
      ],
      "Action": [
        "s3:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "secretsmanager:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "elasticfilesystem:*"
      ]
    },
    {
       "Effect": "Allow",
       "Resource": "*",
       "Action": [
         "cloudwatch:PutDashboard",
         "cloudwatch:GetDashboard",
         "cloudwatch:DeleteDashboards"
       ]
     },
        {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "route53:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "autoscaling:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "elasticloadbalancing:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "rds:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "kms:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "iam:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "codebuild:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "codepipeline:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "codecommit:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "sns:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "cloudwatch:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "lambda:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "backup:*",
        "backup-storage:MountCapsule"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "s3:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "ecr:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "eks:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "cloudtrail:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "acm:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "ssm:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "events:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_codecommit" {
  role       = aws_iam_role.service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

