# VPN Instance
data "template_file" "configure_ipsec" {
  template = "${file("${path.module}/templates/configure_ipsec.sh.tpl")}"

  vars {
    aws_environment_network = "${var.aws_environment_network}"
    office_gateway = "${var.office_gateway}"
    ipsec_shared_secret_key = "${var.ipsec_shared_secret_key}"
    office_network = "${var.office_network}"
    client_network = "${var.client_network}"
  }
}

data "template_cloudinit_config" "init" {
  gzip = false
  base64_encode = false

  part {
    filename = "get_config.sh"
    content_type = "text/x-shellscript"
    content = "${data.template_file.configure_ipsec.rendered}"
  }
}

resource "aws_instance" "vpn_instance" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${split(",", var.security_group_ids)}"]
  subnet_id = "${var.subnet_id}"
  user_data = "${data.template_cloudinit_config.init.rendered}"
  iam_instance_profile = "${var.iam_instance_profile}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "${var.instance_name}"
    env = "${var.env}"
    os = "ubuntu14"
    os_family = "linux"
    service_name = "vpn"
    tier = "dmz"
    datadog = "yes"
    office = "${var.office_name}"
  }
}
