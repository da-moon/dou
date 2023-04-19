packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals { 
  # "timestamp" template function replacement
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
}

source "amazon-ebs" "centos" {
  skip_create_ami             = false
  ami_name                    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-base-ami-${local.timestamp}" : "tc-base-ami-${local.timestamp}"
  instance_type               = "t3.medium"
  source_ami                  = var.base_ami
  region                      = var.region
  ssh_username                = "centos"
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  ami_virtualization_type     = "hvm"
  communicator                = "ssh"
  ssh_pty                     = true
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile

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
    snapshot_id           = var.software_repo_snapshot
  }

  tags = {
    "BuildUUID-tc-base-ami": var.build_uuid
  } 
}

build {
  sources = [
    "source.amazon-ebs.centos"
  ]

  # Copy the config.json file to the server
  provisioner "file" {
    source      = "config.json"
    destination = "/tmp/config.json"
  }

  # Install common yum packages and machine setup
  provisioner "shell" {
    scripts = ["install_base.sh"]
    environment_vars = [
      "REGION=${var.region}",
    ]
  }
}

