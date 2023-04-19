#Requires -Version 5
# vim: filetype=powershell softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
if (-not(Get-Command scoop -ErrorAction SilentlyContinue)) {
  msg="'scoop' was not found in PATH."
  write-host "[ERROR] $msg" -f darkred
  exit 1
}
# ────────────────────────────────────────────────────────────────────
if (-not(Get-Command code -ErrorAction SilentlyContinue)) {
  msg="installing VSCode"
  write-host "[INFO]  $msg" -f darkcyan
  scoop install vscode
  path="$HOME\scoop\apps\vscode\current\vscode-install-context.reg"
  if (Test-Path $path -ErrorAction SilentlyContinue) {
    msg="Updating registry and adding VSCode as a context menu option"
    write-host "[INFO]  $msg" -f darkcyan
    sudo reg import $path
  }
}
# ────────────────────────────────────────────────────────────────────
if (Get-Command code -ErrorAction SilentlyContinue) {
  msg="VSCode install detected. Installing extensions"
  write-host "[INFO]  $msg" -f darkcyan

  msg="ensuring Remote Development Extension Pack is installed"
  write-host "[INFO]  $msg" -f darkcyan
  code --install-extension ms-vscode-remote.remote-containers
  code --install-extension ms-vscode-remote.remote-ssh
  code --install-extension ms-vscode-remote.remote-ssh-edit
  code --install-extension ms-vscode-remote.remote-wsl
  code --install-extension ms-vscode-remote.vscode-remote-extensionpack
  msg="installing helpful extensions"
  write-host "[INFO]  $msg" -f darkcyan
  code --install-extension ms-azuretools.vscode-docker
  code --install-extension chrislajoie.vscode-modelines
  code --install-extension wmaurer.change-case
}
# ────────────────────────────────────────────────────────────────────
msg="installing fonts"
write-host "[INFO] $msg" -f darkcyan
sudo scoop install Open-Sans Cascadia-Code
# ────────────────────────────────────────────────────────────────────
