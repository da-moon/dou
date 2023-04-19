output "rendered_cloud_init" {
  value = data.template_cloudinit_config.init.rendered
}

