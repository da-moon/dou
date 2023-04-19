resource "aws_key_pair" "example" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  iam_instance_profile        = var.iam_instance_profile_server
  subnet_id                   = var.pub_subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.example.key_name
  private_ip                  = "10.0.101.50"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("${var.priv_key}")
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "${var.source_path}/scripts/ec2_user_data_file_bastion.sh"
    destination = "/home/ec2-user/ec2_user_data_file.sh"
  }

  vpc_security_group_ids = [
    var.security_group
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = 50
    encrypted             = true
  }

  user_data = <<-EOT
  #! /bin/bash
  sleep 100
  echo "${var.fsx_dns}" | tee -a /tmp/fsx_dns > /dev/null
  sh /home/ec2-user/ec2_user_data_file.sh
  EOT

  tags = {
    Name        = "${var.vm_name}_bastion_host"
    Environment = var.environment
    OS          = var.os
  }
}

resource "aws_instance" "master" {
  ami                  = var.ami
  instance_type        = "m5.large"
  iam_instance_profile = var.iam_instance_profile_master
  subnet_id            = var.priv_subnet_id
  key_name             = aws_key_pair.example.key_name
  private_ip           = "10.0.1.51"

  provisioner "file" {
    source      = "${var.source_path}/scripts/ec2_user_data_file_master.sh"
    destination = "/home/ec2-user/ec2_user_data_file.sh"

    connection {
      private_key = file("${var.priv_key}")
      type        = "ssh"
      host        = self.private_ip
      user        = "ec2-user"
      timeout     = "5m"

      bastion_host        = aws_instance.bastion.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file("${var.priv_key}")
    }
  }

  provisioner "file" {
    source      = "${var.source_path}/resource_connector"
    destination = "/home/ec2-user/resource_connector"

    connection {
      private_key = file("${var.priv_key}")
      type        = "ssh"
      host        = self.private_ip
      user        = "ec2-user"
      timeout     = "5m"

      bastion_host        = aws_instance.bastion.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file("${var.priv_key}")
    }
  }

  vpc_security_group_ids = [
    var.security_group
  ]
 
  root_block_device {
    delete_on_termination = true
    volume_size           = 50
    encrypted             = true
  }

  user_data = <<-EOT
  #! /bin/bash
  sleep 100
  echo "${var.fsx_dns}" | tee -a /tmp/fsx_dns > /dev/null
  echo "${var.region}" | tee -a /tmp/region > /dev/null
  sed -i "s/_REGION_/${var.region}/g" /home/ec2-user/resource_connector/aws_enable.config
  sed -i "s/_REGION_/${var.region}/g" /home/ec2-user/resource_connector/awsprov_config.json
  sed -i "s/_REGION_/${var.region}/g" /home/ec2-user/resource_connector/awsprov_templates.json
  sed -i "s/_SUBNET_/${var.priv_subnet_id}/g" /home/ec2-user/resource_connector/awsprov_templates.json
  sed -i "s/_KEYPAIR_/${aws_key_pair.example.key_name}/g" /home/ec2-user/resource_connector/awsprov_templates.json
  sed -i "s/_SG_/${var.security_group}/g" /home/ec2-user/resource_connector/awsprov_templates.json
  sed -i "s/_PROFILE_/${var.iam_instance_profile_server}/g" /home/ec2-user/resource_connector/awsprov_templates.json
  sh /home/ec2-user/ec2_user_data_file.sh
  EOT

  tags = {
    Name        = "${var.vm_name}_master_host"
    Environment = var.environment
    OS          = var.os
  }

  depends_on = [
    aws_instance.bastion
  ]
}

resource "aws_instance" "worker" {
  count                = 0
  ami                  = var.ami
  instance_type        = "c5.xlarge"
  iam_instance_profile = var.iam_instance_profile_server
  subnet_id            = var.priv_subnet_id
  key_name             = aws_key_pair.example.key_name

  provisioner "file" {
    source      = "${var.source_path}/scripts/ec2_user_data_file_worker.sh"
    destination = "/home/ec2-user/ec2_user_data_file.sh"

    connection {
      private_key = file("${var.priv_key}")
      type        = "ssh"
      host        = self.private_ip
      user        = "ec2-user"
      timeout     = "5m"

      bastion_host        = aws_instance.bastion.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file("${var.priv_key}")
    }
  }

  vpc_security_group_ids = [
    var.security_group
  ]
  root_block_device {
    delete_on_termination = true
    volume_size           = 50
    encrypted             = true
  }

  user_data = <<-EOT
  #! /bin/bash
  sleep 100
  echo "${var.fsx_dns}" | tee -a /tmp/fsx_dns > /dev/null
  sh /home/ec2-user/ec2_user_data_file.sh
  EOT

  tags = {
    Name        = "${var.vm_name}_worker_host"
    Environment = var.environment
    OS          = var.os
  }
  
  depends_on = [
    aws_instance.bastion,
    aws_instance.master
  ]
}
