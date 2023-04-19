locals {
  website_configuration = merge(var.default_website_configuration, var.website_configuration)
}