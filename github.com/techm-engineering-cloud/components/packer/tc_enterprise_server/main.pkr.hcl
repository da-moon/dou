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
  timestamp          = regex_replace(timestamp(), "[- TZ:]", "") 
  bucket             = split("/", var.install_scripts_path)[0]
  env_name           = split("/", var.install_scripts_path)[2]
  ignore_failures    = var.ignore_tc_errors ? "--ignore-failures" : ""
  processes_to_check = var.start_fsc ? (var.start_pool_mgr ? "fsc,poolmgr" : "fsc") : var.start_pool_mgr ? "poolmgr" : ""
}

source "amazon-ebs" "centos" {
  skip_create_ami             = false
  ami_name                    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.machine_name}-${local.timestamp}" : "tc-${var.machine_name}-${local.timestamp}"
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

  tags = {
    "BuildUUID-tc-${var.machine_name}": var.build_uuid
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

  provisioner "shell" {
    scripts = ["../tc_common/centos/install_common.sh"]
    environment_vars = [
      "MACHINE_NAME=${var.machine_name}"
    ]
  }

  # Mount enterprise server specific EFS volume
  provisioner "shell" {
    scripts = ["../tc_common/centos/mount_efs.sh"]
    environment_vars = [
      "DEST=/usr/Siemens",
      "EFS_ID=${var.tc_efs_id}",
      "REGION=${var.region}"
    ]
  }

  provisioner "file" {
    content = templatefile("fsc_logs.json", {
      machine_name_prefix = substr(var.machine_name, 0, 3)
      env_name            = local.env_name,
      machine_name        = var.machine_name
    })
    destination = "/tmp/fsc_logs.json"
  }

  provisioner "file" {
    content = templatefile("poolmgr_logs.json", {
      machine_name_prefix = substr(var.machine_name, 0, 3)
      env_name            = local.env_name,
      machine_name        = var.machine_name
    })
    destination = "/tmp/poolmgr_logs.json"
  }

  provisioner "shell" {
    scripts = ["install_cw_logs.sh"]
    environment_vars = [
      "install_fsc=${var.start_fsc}",
      "install_poolmgr=${var.start_pool_mgr}"
    ]
  }

  provisioner "file" {
    content = templatefile("update_dns_entry.sh", {
      machine_name            = var.machine_name,
      private_hosted_zone_arn = var.private_hosted_zone_arn,
      private_hosted_zone_dns = var.private_hosted_zone_name,
    })
    destination = "/tmp/update_dns_entry.sh"
  }


  provisioner "file" {
    content = templatefile("update_hostname.service", {
      machine_name = var.machine_name,
    })
    destination = "/tmp/update_hostname.service"
  }

  provisioner "file" {
    source      = "server.mgr_config1_PoolA.service"
    destination = "/var/tmp/server.mgr_config1_PoolA.service"
  }

  provisioner "shell" {
    scripts = ["install_crons.sh"]
  }

  # Copy the install_tc.sh script to the server
  provisioner "file" {
    content = templatefile("../tc_common/centos/install_tc.sh", {
      DC_USER_SECRET_NAME = var.dc_user_secret_name,
      DC_PASS_SECRET_NAME = var.dc_pass_secret_name,
      DC_URL              = var.dc_url,
      BUCKET              = local.bucket,
      ENV_NAME            = local.env_name,
      STAGE_NAME          = var.stage_name,
      START_FSC           = var.start_fsc,
      START_POOL_MGR      = var.start_pool_mgr,
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
      "sudo mv /tmp/update_hostname.service /etc/systemd/system/update_hostname.service",
      "sudo chmod +x /etc/systemd/system/update_hostname.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable update_hostname"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo -E -u tc sh -c 'PATH=$PATH:/usr/local/bin  /home/tc/install_tc.sh --scripts-path ${var.install_scripts_path} ${local.ignore_failures}'"
    ]
  }

}

