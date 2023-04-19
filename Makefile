# vim: filetype=make syntax=make textwidth=0 softtabstop=0 tabstop=4 shiftwidth=4 fileencoding=utf-8 smartindent autoindent noexpandtab
PWD ?= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
ifeq ($(UNAME),Darwin)
	SHELL := /opt/local/bin/bash
	OS_X  := true
else ifneq (,$(wildcard /etc/redhat-release))
	OS_RHEL := true
else
	OS_DEB  := true
	SHELL := /bin/bash
endif
bold := $(shell tput bold)
sgr0 := $(shell tput sgr0)
THIS_FILE := $(firstword $(MAKEFILE_LIST))
SELF_DIR := $(dir $(THIS_FILE))
PROJECT_NAME := $(notdir $(CURDIR))

# ────────────────────────────────────────────────────────────────────────────────
SUBMODULES:=$(notdir $(patsubst %/,%,$(dir $(wildcard ./modules/*/Makefile))))
TFVARS:=$(wildcard ./varfiles/*.tfvars)
# ────────────────────────────────────────────────────────────────────────────────
.DEFAULT_GOAL := default
# ────────────────────────────────────────────────────────────────────────────────
.PHONY: $(shell egrep -o '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/://')
.SILENT: $(shell egrep -o '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/://')
default:
	@$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) $(shell \
		awk -F':' \
		'/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ \
		{\
			split($$1,A,/ /);\
			for(i in A)\
			print A[i]\
		}' $(MAKEFILE_LIST) \
		| sort -u \
		| fzf ; \
	)
# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
help:			## Show this help
	@printf "$$(fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/\s.*##//')\n"
# ────────────────────────────────────────────────────────────────────────────────
init:			## Initialize terraform
	@echo "[INFO] Initiliazing remote state management"
	[ -r .bash.env ] && source .bash.env ; terraform init
# ────────────────────────────────────────────────────────────────────────────────
get:			## Get the Terraform modules.
	@echo "[INFO] Geting Terraform modules"
	[ -r .bash.env ] && source .bash.env ;terraform get
# ────────────────────────────────────────────────────────────────────────────────
plan:	## Plan changes to infrastructure.
	echo "[INFO] Planning changes to infrastructure was completed"
	[ -r .bash.env ] && source .bash.env ; terraform plan
# ────────────────────────────────────────────────────────────────────────────────
refresh:$(REFRESH_TARGETS)		## Refresh the remote state with existing infrastructure.
	@echo "[INFO] Refreshing remote state file was completed"
	[ -r .bash.env ] && source .bash.env ; terraform refresh
# ────────────────────────────────────────────────────────────────────────────────
apply:		## Refresh the remote state with existing infrastructure.
	@echo "[INFO] Refreshing remote state file was completed"
	[ -r .bash.env ] && source .bash.env ; terraform apply -auto-approve
# ────────────────────────────────────────────────────────────────────────────────
output:			## See the output.
	@echo "[INFO] See output"
	[ -r .bash.env ] && source .bash.env ; terraform output -json
# ────────────────────────────────────────────────────────────────────────────────
clean: 		## clean
	@echo "[INFO] Make Clean"
	[ -r .bash.env ] && source .bash.env ; terraform destroy -auto-approve && \
	rm -rf .terraform* *.tfstate.* terraform.tfstate
# ────────────────────────────────────────────────────────────────────────────────
destroy: clean		## Destroy the infrastructure.
	@echo "[INFO] Destroying infrastructure"
# ────────────────────────────────────────────────────────────────────────────────
fmt:			## Format Terraform configuration files.
	@echo "[INFO] Formatting terraform configuration files"
	[ -r .bash.env ] && source .bash.env ; terraform fmt -recursive -write=true
# ────────────────────────────────────────────────────────────────────────────────
validate:		## Validate Terraform configuration.
	@echo "[INFO] Validating terraform configuration files"
	[ -r .bash.env ] && source .bash.env ; terraform validate
# ────────────────────────────────────────────────────────────────────────────────
TFLINT_TARGETS = $(SUBMODULES:%=tflint-%) 
.PHONY: $(TFLINT_TARGETS)
.SILENT: $(TFLINT_TARGETS)
$(TFLINT_TARGETS):
	$(eval name=$(@:tflint-%=%))
	@$(MAKE) --no-print-directory -C modules/$(name)/ tflint
tflint: $(TFLINT_TARGETS) ## Runs essential checks with tflint.
	@echo "[INFO] Running static analysis with TFLint"
	[ -r .bash.env ] && source .bash.env ; tflint --init && tflint $(SELF_DIR)
# ────────────────────────────────────────────────────────────────────────────────
TFSEC_TARGETS = $(SUBMODULES:%=tfsec-%) 
.PHONY: $(TFSEC_TARGETS)
.SILENT: $(TFSEC_TARGETS)
$(TFSEC_TARGETS):
	$(eval name=$(@:tfsec-%=%))
	@$(MAKE) --no-print-directory -C modules/$(name)/ tfsec
tfsec: $(TFSEC_TARGETS) ## Analyze code for potential security issues with tfsec.
	@echo "[INFO] Running static analysis with TFsec"
	[ -r .bash.env ] && source .bash.env ; tfsec $(SELF_DIR)
# ────────────────────────────────────────────────────────────────────────────────
TERRASCAN_TARGETS = $(SUBMODULES:%=terrascan-%) 
.PHONY: $(TERRASCAN_TARGETS)
.SILENT: $(TERRASCAN_TARGETS)
$(TERRASCAN_TARGETS):
	$(eval name=$(@:terrascan-%=%))
	@$(MAKE) --no-print-directory -C modules/$(name)/ terrascan
terrascan: $($(TERRASCAN_TARGETS)) ## Detect compliance and security violations across Infrastructure as Code with Terrascan.
	@echo "[INFO] Running static analysis with Terrascan"
	[ -r .bash.env ] && source .bash.env ; terrascan scan -d $(SELF_DIR) -i terraform 
# ────────────────────────────────────────────────────────────────────────────────
CHECKOV_TARGETS = $(SUBMODULES:%=checkov-%) 
.PHONY: $(CHECKOV_TARGETS)
.SILENT: $(CHECKOV_TARGETS)
$(CHECKOV_TARGETS):
	$(eval name=$(@:checkov-%=%))
	@$(MAKE) --no-print-directory -C modules/$(name)/ checkov
checkov: $(CHECKOV_TARGETS) ## Security and compliance misconfigurations analysis with Checkov using graph-based scanning.
	@echo "[INFO] Running static analysis with Checkov"
	[ -r .bash.env ] && source .bash.env ; checkov -d $(SELF_DIR) --skip-check CKV_DOCKER_* --quiet
# ─── META TARGETS ───────────────────────────────────────────────────────────────
lint: tflint tfsec terrascan checkov ## Meta target for running all static analysis and linter targets 
run: get fmt init validate plan refresh apply output	## Meta target for running all deployment related targets.
	@echo "[INFO] Deploying Terraform"
