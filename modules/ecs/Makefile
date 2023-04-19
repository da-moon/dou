# vim: filetype=make syntax=make textwidth=0 softtabstop=0 tabstop=4 shiftwidth=4 fileencoding=utf-8 smartindent autoindent noexpandtab
# ─── VARIABBLES ─────────────────────────────────────────────────────────────────
CLEAR = clear
LS = ls
TOUCH = touch
CPF = cp -f
RM = rm -rf
RMDIR = sudo rm -rf
MKDIR = mkdir -p
ERRIGNORE = 2>/dev/null
SEP=/
DEVNUL = /dev/null
WHICH = which
# ─── MAKE CONFIG ────────────────────────────────────────────────────────────────
SHELL := /bin/bash
.DEFAULT_GOAL := default
default:
	@if ! $(WHICH) fzf > $(DEVNUL) 2>&1; then \
		make --no-print-directory help ; \
	else  \
		make --no-print-directory $$(make -rpn \
		    | grep -v '^--' \
			| sed -n -e '/^$$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$$// ; p ; } ; }' \
			| grep -vE '^default$$' \
			| sort -u \
			| fzf) ; \
	fi
#  ────────────────────────────────────────────────────────────
.PHONY: $(TARGET_LIST)
.SILENT: $(TARGET_LIST)
TARGET_LIST ?= $(shell $(MAKE) -rpn | sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' | sort -u)

.PHONY: all
all: help

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'

.PHONY: help
help:			## Show this help
	@printf "$$(fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/\s.*##//')\n"

.PHONY: clean
clean: 		## clean
	@echo "[INFO] Make Clean"
	[ -r .env ] && source .env ; terraform destroy -auto-approve && \
	rm -rf .terraform* *.tfstate.* terraform.tfstate

.PHONY: run
run: get fmt init validate plan refresh apply output	## Deploy Terraform.
	@echo "[INFO] Deploying Terraform"

.PHONY: get
get:			## Get the Terraform modules.
	@echo "[INFO] Geting Terraform modules"
	[ -r .env ] && source .env ;terraform get

.PHONY: fmt
fmt:			## Format Terraform configuration files.
	@echo "[INFO] Formatting terraform configuration files"
	[ -r .env ] && source .env ; terraform fmt

.PHONY: init
init:			## Initialize remote S3 backend.cd
	@echo "[INFO] Initiliazing remote state management"
	[ -r .env ] && source .env ; terraform init

.PHONY: validate
validate:		## Validate Terraform configuration.
	@echo "[INFO] Validating terraform configuration files"
	[ -r .env ] && source .env ; terraform validate

.PHONY: plan
plan:			## Plan changes to infrastructure.
	@echo "[INFO] Planning changes to infrastructure"
	[ -r .env ] && source .env ; terraform plan

.PHONY: refresh
refresh:		## Refresh the remote state with existing AWS infrastructure.
	@echo "[INFO] Refreshing remote state file"
	[ -r .env ] && source .env ; terraform refresh

.PHONY: apply
apply:			## Apply the changes in plan.
	@echo "[INFO] Applying changes"
	[ -r .env ] && source .env ; terraform apply -auto-approve

.PHONY: output
output:			## See the output.
	@echo "[INFO] See output"
	[ -r .env ] && source .env ; terraform output -json

.PHONY: destroy
destroy: clean		## Destroy the infrastructure.
	@echo "[INFO] Destroying infrastructure"
