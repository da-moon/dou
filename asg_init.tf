################
#  Cloud Init  #
################

data "template_file" "register_instance" {
  template = file("${path.module}/templates/register_instance.sh.tpl")

  vars = {
    name                 = var.cluster_name
    so_max_conn          = var.cluster_so_max_conn
    ecs_engine_auth_type = var.ecs_engine_auth_type
    ecs_engine_auth_data = var.ecs_engine_auth_data
  }
}

## Create EFS dirs, etc. Bootstrap it
data "template_file" "setup_efs" {
  template = file("${path.module}/templates/setup_efs.sh.tpl")

  vars = {
    dirList = var.efs_directory_init_list
  }
}

## Mount EFS as soon as machine starts, before docker daemon is started, etc.
data "template_file" "mount_efs" {
  template = file("${path.module}/templates/mount_efs.sh.tpl")

  vars = {
    efs_address = var.efs_dns_name
  }
}

data "template_file" "setup_consul_registration" {
  template = file("${path.module}/templates/setup_consul_registration.sh.tpl")

  vars = {
    dns_ip               = var.consul_dns_ip
    consul_client_key    = var.consul_client_key
    datacenter           = "aws-${var.default_region}"
    run_env              = var.run_env
    consul_agent_version = var.consul_agent_version
  }
}

data "template_file" "userify" {
  template = file("${path.module}/templates/userify.sh.tpl")

  vars = {
    api_key = var.userify_group_api_key
    api_id  = var.userify_group_api_id
  }
}

data "template_file" "setup_datadog" {
  template = file("${path.module}/templates/setup_datadog.sh.tpl")

  vars = {
    datadog_api_key = var.datadog_api_key
  }
}

data "template_file" "setup_filebeat" {
  template = file("${path.module}/templates/setup_filebeat.sh.tpl")

  vars = {
    env_url = var.run_env
  }
}

data "template_cloudinit_config" "init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "mount_efs.sh"
    content_type = "text/cloud-boothook"
    content      = data.template_file.mount_efs.rendered
  }

  part {
    filename     = "get_config.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.register_instance.rendered
  }

  part {
    filename     = "setup_efs.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.setup_efs.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.setup_consul_registration.rendered
  }

  part {
    filename     = "userify.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.userify.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.setup_datadog.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.setup_filebeat.rendered
  }
}
