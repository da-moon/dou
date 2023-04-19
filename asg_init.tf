################
#  Cloud Init  #
################

data "template_file" "register_instance" {
  template = file("${path.module}/templates/register_instance.ps1.tpl")

  vars = {
    cluster_name = var.cluster_name
  }
  # so_max_conn = "${var.cluster_so_max_conn}"
  # ecs_engine_auth_type = "${var.ecs_engine_auth_type}"
  # ecs_engine_auth_data = "${var.ecs_engine_auth_data}"
}

# data "template_file" "setup_consul_registration" {
#   template = "${file("${path.module}/templates/setup_consul_registration.sh.tpl")}"
#
#   vars {
#     dns_ip               = "${var.consul_dns_ip}"
#     consul_client_key    = "${var.consul_client_key}"
#     datacenter           = "aws-${var.default_region}"
#     run_env              = var.run_env
#     consul_agent_version = "${var.consul_agent_version}"
#   }
# }
#
# data "template_file" "setup_filebeat" {
#   template = "${file("${path.module}/templates/setup_filebeat.sh.tpl")}"
#
#   vars {
#     env_url = "${var.run_env}"
#   }
# }

data "template_cloudinit_config" "init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "get_config.ps1"
    content_type = "text/x-shellscript"
    content      = data.template_file.register_instance.rendered
  }
  # part {
  #   content_type = "text/x-shellscript"
  #   content      = "${data.template_file.setup_consul_registration.rendered}"
  # }
  #
  # part {
  #   content_type = "text/x-shellscript"
  #   content      = "${data.template_file.setup_filebeat.rendered}"
  # }
}
