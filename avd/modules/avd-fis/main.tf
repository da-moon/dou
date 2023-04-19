
# Resource Group

data "azurerm_resource_group" "avd" {
  name = var.resource_group
}

# Locate the image Packer

data "azurerm_image" "avd_packer" {
  name                = var.packer_name
  resource_group_name = data.azurerm_resource_group.avd.name
}

# Network Resources

resource "azurerm_virtual_network" "avd_vnet" {
  name                = "avd-fis-vnet"
  location            = data.azurerm_resource_group.avd.location
  resource_group_name = data.azurerm_resource_group.avd.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "avd_defaultSubnet" {
  name                 = "avd-fis-subnet"
  resource_group_name  = data.azurerm_resource_group.avd.name
  virtual_network_name = azurerm_virtual_network.avd_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "avd_nsg" {
  name                = "avd-fis-nsg"
  location            = data.azurerm_resource_group.avd.location
  resource_group_name = data.azurerm_resource_group.avd.name
  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "avd_public_ip" {
  count               = var.avd_host_pool_size
  name                = "avd-fis-public-ip-${count.index}"
  resource_group_name = data.azurerm_resource_group.avd.name
  location            = data.azurerm_resource_group.avd.location
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "sessionhost_nic" {
  count               = length(azurerm_public_ip.avd_public_ip)
  name                = "avd-nic-fis-${count.index}"
  location            = data.azurerm_resource_group.avd.location
  resource_group_name = data.azurerm_resource_group.avd.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.avd_defaultSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.avd_public_ip[count.index].id
  }
}

resource "azurerm_subnet_network_security_group_association" "avd_nsg_association" {
  subnet_id                 = azurerm_subnet.avd_defaultSubnet.id
  network_security_group_id = azurerm_network_security_group.avd_nsg.id
}

# AVD Host Pool

resource "azurerm_virtual_desktop_host_pool" "avd" {
  location            = data.azurerm_resource_group.avd.location
  resource_group_name = data.azurerm_resource_group.avd.name

  name                     = "avd-fis-host-pool"
  friendly_name            = "AVD_FIS_Pool"
  validate_environment     = true
  start_vm_on_connect      = true
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;targetisaadjoined:i:1;"
  description              = "AVD FIS Host Pool"
  type                     = "Pooled"
  maximum_sessions_allowed = 10
  load_balancer_type       = "DepthFirst"

}

resource "time_rotating" "avd_registration_expiration" {
  # Must be between 1 hour and 30 days
  rotation_days = 29
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "avd" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avd.id
  expiration_date = time_rotating.avd_registration_expiration.rotation_rfc3339
}

# avd_workspace and App Group

resource "azurerm_virtual_desktop_application_group" "avd_desktopapp" {
  name                = "avd-fis-workspace"
  location            = data.azurerm_resource_group.avd.location
  resource_group_name = data.azurerm_resource_group.avd.name
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.avd.id
  friendly_name       = "AVD-application"
  description         = "AVD Application Group"
}

resource "azurerm_virtual_desktop_workspace" "avd_workspace" {
  name                = "avd-fis-workspace"
  location            = data.azurerm_resource_group.avd.location
  resource_group_name = data.azurerm_resource_group.avd.name
  friendly_name       = "AVD_FIS_WRSPC"
  description         = "Workplace"
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "avd_workspaceremoteapp" {
  workspace_id         = azurerm_virtual_desktop_workspace.avd_workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.avd_desktopapp.id
}

# Session Host VMs

resource "random_id" "avd" {
  count       = length(azurerm_network_interface.sessionhost_nic)
  byte_length = 2
}

resource "random_password" "avd_local_admin" {
  count  = length(azurerm_network_interface.sessionhost_nic)
  length = 64
}

resource "azurerm_windows_virtual_machine" "avd" {
  depends_on = [
    azurerm_network_interface.sessionhost_nic
  ]
  count               = length(random_id.avd)
  name                = "avd-fis-${count.index}"
  resource_group_name = data.azurerm_resource_group.avd.name
  location            = data.azurerm_resource_group.avd.location
  size                = "Standard_D4s_v4"
  admin_username      = "avd-local-admin"
  admin_password      = random_password.avd_local_admin[count.index].result
  provision_vm_agent  = true

  network_interface_ids = [azurerm_network_interface.sessionhost_nic[count.index].id]

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_id = data.azurerm_image.avd_packer.id
}

# Register to Host Pool

locals {
  shutdown_command    = "shutdown -r -t 10"
  exit_code_hack      = "exit 0"
  cmdtorunADDJPrivate = "New-Item -Path HKLM:/SOFTWARE/Microsoft/RDInfraAgent/AADJPrivate"
  cmdtorunNLA         = "Set-ItemProperty -Path 'HKLM:/SOFTWARE/Policies/Microsoft/Windows NT/Terminal Services' -name 'UserAuthentication'   -value '0'"
  ps_cmd  = "${local.cmdtorunADDJPrivate}; ${local.cmdtorunNLA}; ${local.shutdown_command}; ${local.exit_code_hack}"

}

resource "azurerm_virtual_machine_extension" "AVDModule" {
  depends_on = [
    azurerm_windows_virtual_machine.avd
  ]
  count                = length(azurerm_windows_virtual_machine.avd)
  name                 = "Microsoft.PowerShell.DSC"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd.*.id[count.index]
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"
  settings             = <<-SETTINGS
    {
        "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_11-22-2021.zip",
        "ConfigurationFunction": "Configuration.ps1\\AddSessionHost",
        "Properties" : {
          "hostPoolName" : "${azurerm_virtual_desktop_host_pool.avd.name}",
          "aadJoin": true
        }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.avd.token}"
    }
  }
PROTECTED_SETTINGS

}

resource "azurerm_virtual_machine_extension" "AADLoginForWindows" {
  depends_on = [
    azurerm_windows_virtual_machine.avd,
    azurerm_virtual_machine_extension.AVDModule
  ]
  count                      = length(azurerm_windows_virtual_machine.avd)
  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd[count.index].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "CustomScript" {
  depends_on = [
    azurerm_virtual_machine_extension.AADLoginForWindows
  ]
  count                = length(azurerm_windows_virtual_machine.avd)
  name                 = "AADJPRIVATE"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.ps_cmd}\""
    }
SETTINGS
}


# Role-based Access Control

resource "azuread_group" "avd_aad_group" {
  display_name     = "AVD FIS Users"
  security_enabled = true
}

data "azuread_user" "avd_users" {
  for_each            = toset(var.avd_users)
  user_principal_name = each.key
}

resource "azuread_group_member" "avd_users" {
  for_each         = data.azuread_user.avd_users
  group_object_id  = azuread_group.avd_aad_group.id
  member_object_id = each.value.id
}

data "azurerm_role_definition" "avd_vm_user_login" {
  name = "Virtual Machine User Login"
}

resource "azurerm_role_assignment" "vm_user_role" {
  count = length(azurerm_windows_virtual_machine.avd)

  scope              = azurerm_windows_virtual_machine.avd[count.index].id
  role_definition_id = data.azurerm_role_definition.avd_vm_user_login.id
  principal_id       = azuread_group.avd_aad_group.id
}

