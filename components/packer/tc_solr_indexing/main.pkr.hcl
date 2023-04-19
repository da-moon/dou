packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# "timestamp" template function replacement
locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
  bucket    = split("/", var.install_scripts_path)[0]
  env_name  = split("/", var.install_scripts_path)[2]
  ignore_failures = var.ignore_tc_errors ? "--ignore-failures" : ""
}

source "amazon-ebs" "centos" {
  skip_create_ami             = false
  ami_name                    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-solr-indexing-server-base-${local.timestamp}" : "tc-solr-indexing-server-base-${local.timestamp}"
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
  iam_instance_profile        = var.sl_instance_profile

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

  provisioner "shell" {
    scripts = ["../tc_common/centos/install_common.sh"]
    environment_vars = [
      "MACHINE_NAME=${var.machine_name}"
    ]
  }

  # Mount solr server specific EFS volume
  provisioner "shell" {
    scripts = ["../tc_common/centos/mount_efs.sh"]
    environment_vars = [
      "DEST=/usr/Siemens",
      "EFS_ID=${var.tc_efs_id}",
      "REGION=${var.region}"
    ]
  }

  provisioner "file" {
      source      = "solr.service"
      destination = "/tmp/solr.service"
  }

  # Copy the install_tc.sh script to the server
  provisioner "file" {
    content = templatefile("../tc_common/centos/install_tc.sh", {
      DC_USER_SECRET_NAME = var.dc_user_secret_name,
      DC_PASS_SECRET_NAME = var.dc_pass_secret_name,
      SSH_KEY_SECRET_NAME = ""
      DC_URL              = var.dc_url,
      BUCKET              = local.bucket,
      ENV_NAME            = local.env_name,
      STAGE_NAME          = var.stage_name,
      START_FSC           = "false",
      START_POOL_MGR      = "false",
    })
    destination = "/tmp/install_tc.sh"
  }

  # Set permissions and location of install_tc.sh script
  provisioner "shell" {
    inline = [
      "sudo mv /tmp/install_tc.sh /home/tc/install_tc.sh",
      "sudo cd /home/tc",
      "sudo chmod +x /home/tc/install_tc.sh",
      "sudo chown tc:tc /home/tc/install_tc.sh",
      "sudo mv /tmp/solr.service /etc/systemd/system/solr.service",
      "sudo chmod +x /etc/systemd/system/solr.service",
      "sudo systemctl enable solr",
      "sudo systemctl start solr"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo -E -u tc sh -c 'PATH=$PATH:/usr/local/bin  /home/tc/install_tc.sh --scripts-path ${var.install_scripts_path} ${local.ignore_failures}'"
    ]
  }
}
