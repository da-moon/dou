data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "template_file" "init" {
  template = file("${path.root}/userdata.tpl")
  vars     = var.user_data_vars
}
