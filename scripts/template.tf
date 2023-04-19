data "template_file" "install_consul_server" {
  template = "${file("${path.module}/consul/provision-consul-server.sh.tpl")}"

  vars {
    region              = "${var.region}"
    consul_server_nodes = "${var.consul_server_nodes}"
    instance_id_url     = "http://169.254.169.254/latest/meta-data/instance-id"
  }
}

output "install_consul_server" {
  value = "${data.template_file.install_consul_server.rendered}"
}

data "template_file" "install_consul_client" {
  template = "${file("${path.module}/consul/provision-consul-client.sh.tpl")}"

  vars {
    region          = "${var.region}"
    instance_id_url = "http://169.254.169.254/latest/meta-data/instance-id"
  }
}

output "install_consul_client" {
  value = "${data.template_file.install_consul_client.rendered}"
}

data "template_file" "install_vault_server" {
  template = "${file("${path.module}/vault/provision-vault-server.sh.tpl")}"

  vars {
    env_name = "${var.env_name}"
  }
}

output "install_vault_server" {
  value = "${data.template_file.install_vault_server.rendered}"
}
