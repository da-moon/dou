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

source "amazon-ebs" "centos" {
  skip_create_ami             = false
  ami_name                    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-file-server-base-${local.timestamp}" : "tc-file-server-base-${local.timestamp}"
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
  }

  tags = {
    "BuildUUID": var.build_uuid
  } 
}

build {
  sources = [
    "source.amazon-ebs.centos"
  ]

  provisioner "file" {
   source      = "../tc_common/centos/teamcenter_logs.json"
   destination = "/tmp/teamcenter_logs.json"
  }
   provisioner "file" {
   source      = "install_file_server.sh"
   destination = "/home/centos/install_file_server.sh"
  }

  provisioner "shell" {
    scripts = ["../tc_common/centos/install_common.sh"]
    environment_vars = [
      "MACHINE_NAME=${var.machine_name}"
    ]
  }

  # Mount file server specific EFS volume
  provisioner "shell" {
    scripts = ["../tc_common/centos/mount_efs.sh"]
    environment_vars = [
      "DEST=/usr/Siemens",
      "EFS_ID=${var.tc_efs_id}",
      "REGION=${var.region}"
    ]
  }

  provisioner "shell" {
    scripts = ["install_file_server.sh"]
    environment_vars = [
      "USERNAME=tc",
      "SHARE_PATH=/usr/Siemens/Teamcenter13/volumes",
      "SAMBA_PASSWORD=${var.samba_pass}"
    ]
  }
}
