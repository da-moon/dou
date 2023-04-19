packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "repo" {
  ami_name                    = "tc-software-repo-${var.build_uuid}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  region                      = var.region
  ssh_username                = "centos"
  instance_type               = "t3.medium"
  source_ami                  = var.base_ami
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  communicator                = "ssh"
  ssh_pty                     = true
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    encrypted             = true
    kms_key_id            = var.kms_key_id
    delete_on_termination = true
    volume_size           = 10
  }

  launch_block_device_mappings {
    volume_type           = "gp3"
    device_name           = "/dev/sdf"
    encrypted             = true
    kms_key_id            = var.kms_key_id
    delete_on_termination = true
    volume_size           = 50
  }

  snapshot_tags = {
    "Name": "tc-software-repo-${var.build_uuid}"
  }

  tags = {
    "Name": "tc-software-repo-${var.build_uuid}"
  }
}

build {
  sources = [
    "source.amazon-ebs.repo"
  ]

  provisioner "shell" {
    scripts = ["populate_repository.sh"]
    environment_vars = [
      "REGION=${var.region}",
      "SOURCE_S3_URI=${var.source_s3_uri}",
    ]
  }
}
