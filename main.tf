resource "aws_iam_role" "sftp_role" {
  name = "${var.run_env}-transfer-sftp-${var.tenant}-${var.user_name}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF

}

resource "aws_iam_role_policy" "sftp_policy" {
  name = "${var.run_env}-policy-sftp"
  role = aws_iam_role.sftp_role.id

  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "AllowListingOfUserFolder",
              "Action": [
                  "s3:ListBucket",
                  "s3:GetBucketLocation"
              ],
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::${var.bucket}"
              ]
          },
          {
              "Sid": "HomeDirObjectAccess",
              "Effect": "Allow",
              "Action": [
                  "s3:PutObject",
                  "s3:GetObject",
                  "s3:DeleteObjectVersion",
                  "s3:DeleteObject",
                  "s3:GetObjectVersion"
              ],
              "Resource": "arn:aws:s3:::${var.bucket}/*"
          },
          {
              "Sid":"DenyMkdir",
              "Action":[
                "s3:PutObject"
              ],
              "Effect":"Deny",
              "Resource": "arn:aws:s3:::${var.bucket}/*/"
          }
      ]
  }
EOF

}


resource "aws_transfer_user" "user" {
  server_id      = var.sftp_server_id
  user_name      = var.user_name
  role           = aws_iam_role.sftp_role.arn
  home_directory = "/${var.bucket}/${var.tenant}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingOfUserFolder",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::$${transfer:HomeBucket}"
            ],
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "$${transfer:HomeFolder}/*",
                        "$${transfer:HomeFolder}"
                    ]
                }
            }
        },
        {
            "Sid": "HomeDirObjectAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObjectVersion",
                "s3:DeleteObject",
                "s3:GetObjectVersion",
                "s3:GetObjectACL",
                "s3:PutObjectACL"
            ],
            "Resource": "arn:aws:s3:::$${transfer:HomeDirectory}*"
         }
    ]
  }
EOF


  tags = {
    NAME = var.user_name
  }
}

resource "aws_transfer_ssh_key" "sshkey" {
  server_id = var.sftp_server_id
  user_name = aws_transfer_user.user.user_name
  body      = var.sshkey
}
