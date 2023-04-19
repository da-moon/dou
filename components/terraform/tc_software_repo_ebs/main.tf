
locals {
  source_bucket_name = split("/", split("s3://", var.source_s3_uri)[1])[0]
}

## CentOS 7 (x86_64) - with Updates HVM
data "aws_ami" "centos_base_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["CentOS-7-2111-20220825_1.x86_64-d9a3032a-921c-4c6d-b150-bde168105e42"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ssm_parameters_by_path" "own_params" { 
  path      = "/teamcenter/shared/software_repo" 
  recursive = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

locals {
  packer_dir                  = "${path.module}/../../packer/tc_software_repo_ebs"
  changing_rebake_seed        = formatdate("YYYYMMDDhhmmss", timestamp())
  exists_previous_rebake_seed = contains(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/shared/software_repo/rebake_seed")
  index_previous_rebake_seed  = local.exists_previous_rebake_seed ? index(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/shared/software_repo/rebake_seed") : -1
  previous_rebake_seed        = local.exists_previous_rebake_seed ? nonsensitive(data.aws_ssm_parameters_by_path.own_params.values[local.index_previous_rebake_seed]) : local.changing_rebake_seed
  rebake_seed                 = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed
}

resource "null_resource" "packer" {
  triggers = {
    rebake_seed   = local.rebake_seed
    source_s3_uri = var.source_s3_uri
    dir_sha1      = sha1(join("", [for f in fileset(local.packer_dir, "*") : filesha1(format("%s/%s", local.packer_dir, f))]))
  }

  provisioner "local-exec" {
    working_dir = local.packer_dir
    environment = {
      AWS_MAX_ATTEMPTS       = 180
      AWS_POLL_DELAY_SECONDS = 30
    }
    command = <<EOF
packer build \
  -var 'vpc_id=${data.aws_subnet.selected.vpc_id}' \
  -var 'subnet_id=${var.subnet_id}' \
  -var 'iam_instance_profile=${aws_iam_instance_profile.main.id}' \
  -var 'region=${data.aws_region.current.name}' \
  -var 'kms_key_id=${var.kms_key_id}' \
  -var 'base_ami=${data.aws_ami.centos_base_ami.id}' \
  -var 'source_s3_uri=${var.source_s3_uri}' \
  -var 'build_uuid=${local.rebake_seed}' \
  -machine-readable .

if [ ! $? -eq 0 ]; then
  echo "=== Packer Failed ==="
  exit 1
fi

EOF
  }
}

data "aws_ebs_snapshot" "software_repo" {
  depends_on = [
    null_resource.packer
  ]
  most_recent = true

  filter {
    name   = "tag:Name"
    values = ["tc-software-repo-${local.rebake_seed}"]
  }
  filter {
    name   = "volume-size"
    values = ["50"]
  }
}

resource "aws_ssm_parameter" "rebake_seed" {
  name           = "/teamcenter/shared/software_repo/rebake_seed"
  type           = "String"
  insecure_value = local.rebake_seed
  overwrite      = true
}

resource "aws_ssm_parameter" "snapshot_id" {
  name           = "/teamcenter/shared/software_repo/ebs_snapshot_id"
  type           = "String"
  insecure_value = data.aws_ebs_snapshot.software_repo.id
  overwrite      = true
}

resource "aws_iam_instance_profile" "main" {
  name = "software-repo"
  role = aws_iam_role.main.name
}

resource "aws_iam_role" "main" {
  name = "software-repo"

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

resource "aws_iam_role_policy" "policy" {
  name = "software-repo"
  role = aws_iam_role.main.id

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
            "Resource": "arn:aws:s3:::${local.source_bucket_name}"
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${local.source_bucket_name}/*"
        }
    ]
}
EOF
}

