source "azure-arm" "avd" {
  # WinRM Communicator

  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "12h"
  winrm_username = "packer"
  winrm_port = 5986

  # Service Principal Authentication

  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  # Source Image

  os_type         = "Windows"
  image_publisher = var.source_image_publisher
  image_offer     = var.source_image_offer
  image_sku       = var.source_image_sku
  image_version   = var.source_image_version

  # Destination Image

  managed_image_resource_group_name = var.artifacts_resource_group
  managed_image_name                = var.managed_image_name

  # Packer Computing Resources

  build_resource_group_name = var.build_resource_group
  vm_size                   = "Standard_D4s_v4"
}

build {
  sources = ["source.azure-arm.avd"]


  # Configure for WINRM communication for ansible
  provisioner "powershell" {
    script = "../scripts/ConfigureRemotingForAnsible.ps1"
  } 

  # Ansible configuration for the image
  provisioner "ansible" {
      ansible_env_vars = ["no_proxy=\"*\""]
      playbook_file   = "../playbooks/playbook-devicewise.yml"
      user            = "packer"
      use_proxy       = false
      extra_arguments = [
        "-e",
        "ansible_winrm_server_cert_validation=ignore",
        "--extra-vars", "azure_login_username=${var.azure_login_username} azure_login_password=${var.azure_login_password} azure_artifact_org=${var.azure_artifact_org}  azure_artifact_username=${var.azure_artifact_username}  azure_artifact_version=${var.azure_artifact_version} workbench_filename=${var.azure_artifact_filename_workbench}  gateway_filename=${var.azure_artifact_filename_gateway}",
      ]
  }

  # Generalize image using Sysprep
  # See https://www.packer.io/docs/builders/azure/arm#windows
  # See https://docs.microsoft.com/en-us/azure/virtual-machines/windows/build-image-with-packer#define-packer-template
  provisioner "powershell" {
    inline = [
      "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
      "while ($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}
