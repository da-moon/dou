# This file was autogenerated by the 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# All generated input variables will be of 'string' type as this is how Packer JSON
# views them; you can change their type later on. Read the variables type
# constraints documentation
# https://www.packer.io/docs/templates/hcl_templates/variables#type-constraints for more info.
variable "query_ami" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "subnet" {
  type    = string
}

variable "base_ami" {
  type    = string
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "playbook" {
  type    = string
}

variable "os_ansible_install" {
  type    = string
  default = "install_ansible"
}

variable "vpc" {
  type    = string
}

variable "requirements_path" {
  type    = string
}

variable "description" {
  type    = string
  default = "Packer created image"
}

variable "name" {
  type    = string
}

variable "version" {
  type    = string
}

variable "access_key" {
  type    = string
}


variable "secret_key" {
  type    = string
}

variable "kms_key_id" {
  type = string
}

variable "git_username" {
  type = string
  default = "ubuntu"
}

variable "git_password" {
  type = string
  default = "password"
}


# The amazon-ami data block is generated from your amazon builder source_ami_filter; a data
# from this block can be referenced in source and locals blocks.
# Read the documentation for data blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/data
# Read the documentation for the Amazon AMI Data Source here:
# https://www.packer.io/docs/datasources/amazon/ami
// data "amazon-ami" "iidk_base" {
//   access_key = "${var.access_key}"
//   filters = {
//     name                = "${var.query_ami}-*"
//     root-device-type    = "ebs"
//     virtualization-type = "hvm"
//   }
//   most_recent = true
//   owners      = ["099720109477"]
//   region      = "${var.region}"
//   secret_key  = "${var.secret_key}"
// }

// data "amazon-ami" "iidk_base" {
//   access_key = "${var.access_key}"
//   secret_key  = "${var.secret_key}"
//   region      = "${var.region}"
//   filters = {
//       virtualization-type = "hvm"
//       name = "${var.query_ami}-*"
//       root-device-type = "ebs"
//   }
//   owners = ["099720109477"]
//   most_recent = true
// }

data "amazon-ami" "iidk_base" {
    filters = {
        virtualization-type = "hvm"
        name = "${var.base_ami}"
        root-device-type = "ebs"
    }
    owners = ["099720109477"]
    most_recent = true
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "amazon-ebs" "iidk_base" {
  access_key              = "${var.access_key}"
  ami_description         = "${var.description}"
  ami_name                = "${var.name}-${local.timestamp}"
  ami_regions             = ["${var.region}"]
  ami_virtualization_type = "hvm"
  communicator            = "ssh"
  instance_type           = "t4g.nano"
  region                  = "${var.region}"
  secret_key              = "${var.secret_key}"
  source_ami              = "${data.amazon-ami.iidk_base.id}"
  ssh_pty                 = true
  encrypt_boot            = true
  kms_key_id              = "${var.kms_key_id}"
  ssh_username            = "${var.ssh_username}"
  subnet_id               = "${var.subnet}"
  tags = {
    Name      = "${var.name}"
    manageby  = "packer"
    os        = "${data.amazon-ami.iidk_base.name}"
    storage   = "ebs"
    timestamp = "${local.timestamp}"
    version   = "${var.version}"
  }
  vpc_id = "${var.vpc}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.amazon-ebs.iidk_base"]

  provisioner "shell" {
    scripts = ["../scripts/apt_upgrade.sh", "../scripts/${var.os_ansible_install}.sh"]
  }

  provisioner "shell" {
    inline = [
    "echo Create git netrc",
    "touch ~/.netrc",
    "echo 'machine github.com' >> ~/.netrc",
    "echo 'login ${var.git_username}' >> ~/.netrc |tee",
    "echo 'password ${var.git_password}' >> ~/.netrc |tee"
    ]
  }

  provisioner "ansible-local" {
    galaxy_file = "${var.requirements_path}/requirements.yml"
    galaxy_command = "ansible-galaxy"
    inventory_groups = ["${var.playbook}"]
    playbook_dir     = "../../linux/ubuntu/playbooks/"
    playbook_file    = "../../linux/ubuntu/playbooks/${var.playbook}.yml"
  }

  provisioner "shell" {
    scripts = ["../scripts/ec2_bundle_vol.sh"]
  }

}
