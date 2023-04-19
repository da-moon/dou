packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
source "amazon-ebs" "redhat" {
  ami_name             = var.ami_name
  vpc_id               = var.vpc_id
  subnet_id            = var.pub_subnets[0]
  instance_type        = var.instance_type
  region               = var.region
  source_ami           = var.source_ami
  iam_instance_profile = var.role
  ami_users            = var.ami_user
  ssh_username         = var.ssh_username
  tags = {
    Name = "eda-aws-ami"
  }
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.redhat"
  ]
  provisioner "file" {
    source      = "../terraform_output/fsx_openzfs_dns_name"
    destination = "/tmp/fsx_dns"
  }

  provisioner "shell" {
    script = "../scripts/ec2_user_data_file_ami.sh"
  }

  post-processor "manifest" {
    output = "../resource_connector/packer_manifest.json"
  }
}