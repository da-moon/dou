#Requires -Version 5
# vim: filetype=powershell softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
if (-not(Get-Command scoop -ErrorAction SilentlyContinue)) {
  msg="'scoop' was not found in PATH.Installing ..."
  write-host "[INFO]  $msg" -f darkcyan
  Set-ExecutionPolicy Bypass -Scope Process -Force
  iwr -useb get.scoop.sh | iex
  # ────────────────────────────────────────────────────────────────────
  scoop install git
  # ────────────────────────────────────────────────────────────────────
  msg="Adding all available 'scoop' buckets ..."
  write-host "[INFO]  $msg" -f darkcyan
  $(scoop bucket known).split() | ForEach-Object{ scoop bucket add $_.trim()}
  # ────────────────────────────────────────────────────────────────────
  scoop install gsudo
}
code --install-extension ms-azuretools.vscode-docker
code --install-extension chrislajoie.vscode-modelines
code --install-extension wmaurer.change-case
