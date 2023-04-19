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
  prefix    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}" : "tc-${var.env_name}"
}

source "amazon-ebs" "centos" {
  skip_create_ami             = false
  ami_name                    = "${local.prefix}-build-server-${local.timestamp}"
  instance_type               = var.instance_type
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
    "BuildUUID-build-server": var.build_uuid
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

  provisioner "shell" {
    scripts = ["install_build_server.sh"]
  }

  provisioner "file" {
    content = templatefile("db/create.sql", {
      sm_db_name   = var.sm_db_name,
    })
    destination = "/tmp/create.sql"
  }

  provisioner "file" {
    content = templatefile("db/delete.sql", {
      sm_db_name = var.sm_db_name, 
    })
    destination = "/tmp/delete.sql"
  }

  provisioner "file" {
    content = templatefile("db/init_db.sh", {
      DB_USER      = var.db_admin_user_name, 
      DB_PASS      = var.db_admin_pass_name,
      DB_HOST      = var.db_host,
      DB_SID       = var.db_sid,
      SM_USER      = var.sm_db_user_name, 
      SM_PASS      = var.sm_db_pass_name,
      INFODBA_USER = var.infodba_user_name,
      INFODBA_PASS = var.infodba_pass_name,
    })
    destination = "/tmp/init_db.sh"
  }

  provisioner "file" {
    source      = "kubernetes/storageclass.yaml"
    destination = "/tmp/storageclass.yaml"
  }

  provisioner "file" {
    content = templatefile("kubernetes/filerepo_persistentvolume.yaml", {
      EFS_ID = var.tc_efs_id,
      NAMESPACE = var.namespace,
    })    
    destination = "/tmp/filerepo_persistentvolume.yaml"
  }

  provisioner "file" {
    content = templatefile("kubernetes/filerepo_pvc.yaml", {
      NAMESPACE = var.namespace,
    })    
    destination = "/tmp/filerepo_pvc.yaml"
  }

  provisioner "file" {
    content = templatefile("kubernetes/deploy.sh", {
      REGION               = var.region,
      NAMESPACE            = var.namespace,
      KEYSTORE_SECRET_NAME = var.keystore_secret_name,
    })
    destination = "/tmp/deploy.sh"
  }

  # Mount teamcenter EFS volume
  provisioner "shell" {
    scripts = ["../tc_common/centos/mount_efs.sh"]
    environment_vars = [
      "DEST=/usr/Siemens",
      "EFS_ID=${var.tc_efs_id}",
      "REGION=${var.region}"
    ]
  }

  provisioner "file" {
    content = templatefile("update_hostname.service", {
      machine_name = var.machine_name,
    })
    destination = "/tmp/update_hostname.service"
  }

  # Copy the install_tc.sh script to the server
  provisioner "file" {
    content = templatefile("../tc_common/centos/install_tc.sh", {
      DC_USER_SECRET_NAME = "/teamcenter/shared/deployment_center/username",
      DC_PASS_SECRET_NAME = "/teamcenter/shared/deployment_center/password",
      DC_URL              = var.dc_url,
      BUCKET              = var.deploy_scripts_s3_bucket,
      ENV_NAME            = var.env_name,
      STAGE_NAME          = "build_server",
      START_FSC           = "false",
      START_POOL_MGR      = "false",
    })
    destination = "/tmp/install_tc.sh"
  }

  # Set permissions and location of install_tc.sh script
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /home/tc/db/",
      "sudo mv /tmp/create.sql /home/tc/db/",
      "sudo mv /tmp/delete.sql /home/tc/db/",
      "sudo mv /tmp/init_db.sh /home/tc/db/",
      "sudo mkdir -p /home/tc/kubernetes/",
      "sudo mv /tmp/storageclass.yaml /home/tc/kubernetes/",
      "sudo mv /tmp/filerepo_persistentvolume.yaml /home/tc/kubernetes/",
      "sudo mv /tmp/filerepo_pvc.yaml /home/tc/kubernetes/",
      "sudo mv /tmp/deploy.sh /home/tc/kubernetes/",
      "sudo mv /tmp/install_tc.sh /home/tc/install_tc.sh",
      "sudo cd /home/tc",
      "sudo chmod -R +x /home/tc/db",
      "sudo chmod -R +x /home/tc/kubernetes",
      "sudo chmod +x /home/tc/install_tc.sh",
      "sudo chown -R tc:tc /home/tc/db",
      "sudo chown -R tc:tc /home/tc/kubernetes",
      "sudo chown tc:tc /home/tc/install_tc.sh",
      "sudo mv /tmp/update_hostname.service /etc/systemd/system/update_hostname.service",
      "sudo chmod +x /etc/systemd/system/update_hostname.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable update_hostname"
    ]
  }

}

