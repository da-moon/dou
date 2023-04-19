data "template_file" "configure_service" {
  template = var.service_template_file

  vars = var.service_template_vars
}


data "template_cloudinit_config" "init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = var.service_template_name
    content_type = "text/x-shellscript"
    content      = data.template_file.configure_service.rendered
  }
}
