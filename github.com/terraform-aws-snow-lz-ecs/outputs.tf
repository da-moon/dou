# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

output "application_url" {
  value = module.alb.dns_name
  description = "url of the deployed web server"
}
