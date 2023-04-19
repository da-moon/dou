#--------------
# ACI caas api
#--------------
resource "azurerm_container_group" "example" {
  name                = "example-continst"
  location            = "eastus"
  resource_group_name = "valkyrie-test"
  ip_address_type     = "public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "django-hello-world"
    image  = var.image
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  tags = {
    environment = "Learning" # In case your using tags
    owner       = "dou"
    project     = "AZ-CaaS"
  }
}


output "postgres_data" {
  value = data.terraform_remote_state.postgres.outputs.postgres_data
}
