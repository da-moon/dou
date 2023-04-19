# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = ">=2.20.0"

  features {}
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.landing_zone.outputs.host
  username               = data.terraform_remote_state.landing_zone.outputs.cluster_username
  password               = data.terraform_remote_state.landing_zone.outputs.cluster_password
  client_certificate     = data.terraform_remote_state.landing_zone.outputs.client_certificate
  client_key             = data.terraform_remote_state.landing_zone.outputs.client_key
  cluster_ca_certificate = data.terraform_remote_state.landing_zone.outputs.cluster_ca_certificate
}
