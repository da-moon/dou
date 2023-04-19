###############
#  S3 Bucket  #
###############

provider "aws" {
}

provider "aws" {
  alias = "dest"
}

# This is the source s3 bucket
resource "aws_s3_bucket" "bucket" {
  count =  var.check
  region = "${var.primary_region}"
  bucket = "cv-${var.name_prefix}-${var.name}"
  acl    = var.acl
  policy = data.template_file.policy.rendered
  versioning {
    enabled = var.versioning
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    name = "cv-${var.name_prefix}-${var.name}"
  }
  replication_configuration {
      role = "${aws_iam_role.replication[0].arn}"
      rules {
          id     = "replica"
          status = "Enabled"

          destination {
              bucket        = "${aws_s3_bucket.replica[0].arn}"
              storage_class = "STANDARD"
          }
      }
  }
}

#Replication bucket
resource "aws_s3_bucket" "replica" {
  count    =  var.check
  provider = "aws.dest"
  bucket = "cv-${var.dr_name_prefix}-${var.name}"
  region = "${var.dr_region}"
  acl    = var.acl
  policy = data.template_file.policy.rendered
  versioning {
    enabled = var.versioning
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    name = "cv-${var.dr_name_prefix}-${var.name}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

data "template_file" "policy" {
  count =  var.check
  template = file("${path.module}/policy.json.tpl")
  vars = {
    bucket_id = "cv-${var.name_prefix}-${var.name}"
    cidr1     = var.cidr1
    cidr2     = var.cidr2
    cidr3     = var.cidr3
    cidr4     = var.cidr4
    cidr5     = var.cidr5
    cidr6     = var.cidr6
  }
}

data "template_file" "policy_repl" {
  count =  var.check
  template = file("${path.module}/policy_dr.json.tpl")
  vars = {
    bucket_id = "cv-${var.dr_name_prefix}-${var.name}"
    cidr1     = var.cidr1
    cidr2     = var.cidr2
    cidr3     = var.cidr3
    cidr4     = var.cidr4
    cidr5     = var.cidr5
    cidr6     = var.cidr6
  }
}


# Create replication role
resource "aws_iam_role" "replication" {
  count =  var.check
  name               = "s3-role-replication-${var.name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
    count =  var.check
    name = "s3-policy-replication-${var.name}"
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket[0].arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket[0].arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.replica[0].arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
    count =  var.check
    name = "role-attachment-replication-${var.name}"
    roles = ["${aws_iam_role.replication[0].name}"]
    policy_arn = "${aws_iam_policy.replication[0].arn}"
}
