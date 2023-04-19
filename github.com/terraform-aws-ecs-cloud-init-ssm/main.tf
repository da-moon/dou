################
#  Cloud Init  #
################

data "template_file" "register_instance" {
  template = file("${path.module}/templates/register_instance.sh.tpl")
  vars = {
    cluster_name = var.cluster_name
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

data "template_file" "setup_efs" {
  template = file("${path.module}/templates/setup_efs.sh.tpl")
  vars = {
    efs_address = var.efs_address
  }
}

data "template_cloudinit_config" "init" {
  gzip          = false
  base64_encode = false

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
    filename     = "userify.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.userify.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.setup_datadog.rendered
  }
}

