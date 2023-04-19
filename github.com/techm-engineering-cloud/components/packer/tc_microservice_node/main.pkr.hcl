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


source "amazon-ebs" "swarm" {
  region                      = var.region
  ami_name                    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.machine_name}-${local.timestamp}" : "tc-${var.machine_name}-${local.timestamp}"
  ssh_username                = "centos"
  instance_type               = "t3.medium"
  source_ami                  = var.base_ami
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  ami_virtualization_type     = "hvm"
  communicator                = "ssh"
  ssh_pty                     = true
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile

    tags = {
    "BuildUUID-tc-${var.machine_name}": var.build_uuid
  } 
}

build {
  sources = [
    "source.amazon-ebs.swarm"
  ]

  provisioner "shell" {
    scripts = ["../tc_common/centos/install_common.sh"]
    environment_vars = [
      "MACHINE_NAME=${var.machine_name}"
    ]
  }

  # Mount TC EFS volume
  provisioner "shell" {
    scripts = ["../tc_common/centos/mount_efs.sh"]
    environment_vars = [
      "DEST=/usr/Siemens",
      "EFS_ID=${var.tc_efs_id}",
      "REGION=${var.region}"
    ]
  }  

  provisioner "shell" {
    scripts = ["install_ms.sh"]
    environment_vars = [
      "FILE_REPO_PATH=${var.file_repo_path}"
    ]
  }

  provisioner "shell" {
    inline = [
       "sudo -u tc docker login --username AWS --password $(aws ecr get-login-password --region ${var.region}) ${var.ecr_registry}"
    ]
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

  provisioner "file" {
    content = templatefile("tc_post_install.sh", {
      ECR_REGISTRY         = var.ecr_registry,
      KEYSTORE_SECRET_NAME = var.keystore_secret_name,
    })
    destination = "/tmp/tc_post_install.sh"
  }

  provisioner "file" {
    content = templatefile("start_stack.sh", {
      ECR_REGISTRY = var.ecr_registry,
      IS_MANAGER = var.is_manager,
      BUCKET     = local.bucket,
      ENV_NAME   = local.env_name,
      STAGE_NAME = var.stage_name,
    })
    destination = "/tmp/start_stack.sh"
  }

  # Set permissions and location of install_tc.sh script
  provisioner "shell" {
    
    inline = [
      "sudo mv /tmp/install_tc.sh /home/tc/install_tc.sh",
      "sudo chmod +x /home/tc/install_tc.sh",
      "sudo chown tc:tc /home/tc/install_tc.sh",
      "sudo mv /tmp/start_stack.sh /home/tc/start_stack.sh",
      "sudo chmod +x /home/tc/start_stack.sh",
      "sudo chown tc:tc /home/tc/start_stack.sh",
      "sudo mv /tmp/tc_post_install.sh /home/tc/tc_post_install.sh",
      "sudo chmod +x /home/tc/tc_post_install.sh",
      "sudo chown tc:tc /home/tc/tc_post_install.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo -E -u tc sh -c 'PATH=$PATH:/usr/local/bin  /home/tc/install_tc.sh --scripts-path ${var.install_scripts_path} ${local.ignore_failures}'"
    ]
  }

}
