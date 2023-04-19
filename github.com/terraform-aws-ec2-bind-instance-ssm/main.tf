# BIND Instance
data "template_file" "configure_bind" {
  template = file("${path.module}/templates/configure_bind.sh.tpl")

  vars = {
    internal_route53_address  = var.internal_route53_address
    directory_services_domain = var.directory_services_domain
    directory_services_ip1    = var.directory_services_ip1
    directory_services_ip2    = var.directory_services_ip2
  }
}

data "template_cloudinit_config" "init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "get_config.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.configure_bind.rendered
  }
}

resource "aws_instance" "bind_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = split(",", var.security_group_ids)
  subnet_id              = var.subnet_id
  user_data              = data.template_cloudinit_config.init.rendered
  iam_instance_profile   = var.iam_instance_profile
  private_ip             = var.bind_ipaddress

  tags = {
    Name         = var.instance_name
    env          = var.env
    os           = "ubuntu14"
    os_family    = "linux"
    service_name = "bind"
    tier         = "app"
    datadog      = "yes"
  }
}

