#build/exec env setting
DOCKER_ENV:=false
DELAY:=
# golang specific vars
GO_PKG:=github.com/da-moon/kvctl
GO_IMAGE=golang:buster
MOD=on
CGO=
GO_ARCHITECTURE=
# variables for demo
LOG_LEVEL=
MOUNT_POINT="/mnt/vault"

ENGINE_MOUNT="certificates"
EXAMPLE_DIR="fixtures/example"
KEY_PREFIX=
