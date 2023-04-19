
resource "aws_iam_role" "sftp_logging_role" {
  name = "${var.run_env}-logging-sftp"

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

resource "aws_iam_role_policy" "sftp_logging_policy" {
  name = "${var.run_env}-logging-sftp"
  role = aws_iam_role.sftp_logging_role.id

  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
            {
                  "Sid": "VisualEditor0",
                  "Effect": "Allow",
                  "Action": [
                        "logs:CreateLogStream",
                        "logs:DescribeLogStreams",
                        "logs:CreateLogGroup",
                        "logs:PutLogEvents"
                  ],
                  "Resource": "*"
            }
      ]
}
EOF

}

resource "aws_transfer_server" "sftp_server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.sftp_logging_role.arn

  tags = {
    NAME = "${var.run_env}-sftp"
    ENV  = var.run_env
  }
}



resource "aws_route53_record" "sftp_env_corvesta_net" {
  zone_id = var.hostedzone_id
  name    = "sftp-${var.name}"
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_transfer_server.sftp_server.endpoint,
  ]
}
