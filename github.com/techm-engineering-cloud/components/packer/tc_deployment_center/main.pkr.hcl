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

data "amazon-secretsmanager" "dc_admin_pass" {
  name = var.dc_admin_pass_name
}

source "amazon-ebs" "ubuntu" {
  skip_create_ami             = false
  ami_name                    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-deployment-center-${local.timestamp}" : "tc-deployment-center-${local.timestamp}"
  instance_type               = var.instance_type
  source_ami                  = var.base_ami
  ssh_username                = "ubuntu"
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
    volume_size           = 20
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
    "BuildUUID-dc": var.build_uuid
  }
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "config.json"
    destination = "/tmp/config.json"
  }

  provisioner "file" {
    source      = "deployment_log_files.json"
    destination = "/tmp/deployment_log_files.json"
  }

  provisioner "shell" {
    scripts = ["install_base.sh"]
    environment_vars = [
      "REGION=${var.region}",
      "MACHINE_NAME=${var.machine_name}"
    ]
  }

  provisioner "file" {
    source = "install_config.properties"
    destination = "/tmp/install_config.properties"
  }

  provisioner "file" {
    source = "sync_deployment_scripts.sh"
    destination = "/tmp/"
  }

  provisioner "file" {
    source = "generate_deployment_scripts.py"
    destination = "/tmp/generate_deployment_scripts.py"
  }

  provisioner "file" {
    source = "install_deployment_center.sh"
    destination = "/tmp/install_deployment_center.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo chmod +x /tmp/install_deployment_center.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo -E -u tc sh -c 'PATH=$PATH:/usr/local/bin  /tmp/install_deployment_center.sh'"
    ]
    environment_vars = [
      "EFS_ID=${var.dc_efs_id}",
      "REGION=${var.region}",
      "DELETE_DATA=${var.delete_data}",
      "DC_ADMIN_USER=${var.dc_admin_user}",
      "DC_ADMIN_PASS=${data.amazon-secretsmanager.dc_admin_pass.secret_string}",
      "MACHINE_NAME=${var.machine_name}",
      "DC_FOLDER_TO_INSTALL=${var.dc_folder_to_install}",
      "ARTIFACTS_BUCKET=${var.artifacts_bucket}",
    ]
  }

  provisioner "shell" {
    scripts = ["install_cloudwatch_agent.sh"]
    environment_vars = [
      "MACHINE_NAME=${var.machine_name}",
    ]
  }
}

