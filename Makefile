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
# ────────────────────────────────────────────────────────────────────────────────
LUA_VERSION = $(shell find '/usr/bin' -type f -name 'luarocks-5*' | sed 's/^.*-//')
PROJECT_NAME := $(notdir $(CURDIR))
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
# ─── HIDDEN TARGETS ─────────────────────────────────────────────────────────────
--fix-home-ownership:
	export PATH=$(PATH) ;
	@find "$${HOME}" \
		-not -group "$(shell id -g)" \
		-not -user "$(shell id -u)" \
		-print0 | \
		xargs -0 -r -I {} -P "$(shell nproc)" \
		sudo chown --no-dereference "$(shell id -u):$(shell id -g)" {} ;
--rust:
	export PATH=$(PATH) ;
	@if ! $(WHICH) cargo > $(DEVNUL) 2>&1; then \
		if $(WHICH) pacman > $(DEVNUL) 2>&1; then \
			sudo pacman -Syy --noconfirm --needed rust sccache ; \
		elif $(WHICH) apk > $(DEVNUL) 2>&1; then \
			sudo apk info --installed "cargo" > $(DEVNUL) 2>&1 || sudo apk add --no-cache "cargo" ; \
			sudo apk info --installed "sccache" > $(DEVNUL) 2>&1 || sudo apk add --no-cache "sccache" ; \
		fi \
	fi
--vale:
	export PATH=$(PATH) ;
	@if ! $(WHICH) selene > $(DEVNUL) 2>&1; then \
		if $(WHICH) makepkg > $(DEVNUL) 2>&1; then \
			$(RMDIR) "/tmp/vale-bin" \
			&& git clone "https://aur.archlinux.org/vale-bin.git" "/tmp/vale-bin" \
			&& pushd "/tmp/vale-bin" \
			&& makepkg -sicr --noconfirm \
			&& popd \
			&& $(RMDIR) "/tmp/vale-bin" ; \
		else \
			curl -sfL https://install.goreleaser.com/github.com/ValeLint/vale.sh | sudo sh -s -- -b "/usr/local/bin" latest ; \
		fi \
	fi
--fd:
	export PATH=$(PATH) ;
	@if ! $(WHICH) fd > $(DEVNUL) 2>&1; then \
		if $(WHICH) pacman > $(DEVNUL) 2>&1; then \
			sudo pacman -Syy --noconfirm --needed fd ; \
		elif $(WHICH) apk > $(DEVNUL) 2>&1; then \
			sudo apk add --no-cache fd	; \
		elif $(WHICH) cargo > $(DEVNUL) 2>&1; then \
			cargo install -j$(shell nproc) fd-find ; \
		fi \
	fi

#  ────────────────────────────────────────────────────────────────────
help:                   ## Show main help menu
	echo '─── main help menu ─────────────────────────────────────────────────────────────'
	if ! $(WHICH) column > $(DEVNUL) 2>&1; then \
		printf "$$(fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v 'fgrep' | sed -e 's/\\$$//' | sed -e 's/\s.*##//')\n" ; \
	else  \
		printf "$$(fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v 'fgrep' | sed -e 's/\\$$//' | sed -e 's/\s.*##//')\n" \
		| column -t  \
		| sed -re 's/: ( +)/\1: /' -e 's/ +/ /2g' ; \
	fi
	$(MAKE) --no-print-directory -C contrib/sandbox help-sandbox
#  ╭──────────────────────────────────────────────────────────╮
#  │                       git targets                        │
#  ╰──────────────────────────────────────────────────────────╯
PATCHVERSION ?= $(shell git describe --tags --abbrev=0 | sed s/v// | awk -F. '{print $$1"."$$2"."$$3+1}')
patch-release: ## bump up tags for a new Patch release.
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	git checkout '$(shell git rev-parse --abbrev-ref HEAD)' \
	&& git pull \
	&& git fetch -p && git branch -vv | awk '/: gone]/ {print $$1}' | xargs -r -I {} git branch -D '{}' \
	&& git tag -a v$(PATCHVERSION) -m 'release $(PATCHVERSION)' \
	&& git push origin --tags
	echo '────────────────────────────────────────────────────────────────────────────────' ;

MINORVERSION ?= $(shell git describe --tags --abbrev=0 | sed s/v// | awk -F. '{print $$1"."$$2+1".0"}')
minor-release: ## bump up tags for a new Minor release
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	git checkout '$(shell git rev-parse --abbrev-ref HEAD)' \
	&& git pull \
	&& git fetch -p && git branch -vv | awk '/: gone]/ {print $$1}' | xargs -r -I {} git branch -D '{}' \
	&& git tag -a v$(MINORVERSION) -m 'release $(MINORVERSION)' \
	&& git push origin --tags
	echo '────────────────────────────────────────────────────────────────────────────────' ;

MAJORVERSION ?= $(shell git describe --tags --abbrev=0 | sed s/v// |  awk -F. '{print $$1+1".0.0"}')
major-release: ## bump up tags for a new Major release
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ; \
	git checkout '$(shell git rev-parse --abbrev-ref HEAD)' \
	&& git pull \
	&& git fetch -p && git branch -vv | awk '/: gone]/ {print $$1}' | xargs -r -I {} git branch -D '{}' \
	&& git tag -a v$(MAJORVERSION) -m 'release $(MAJORVERSION)' \
	&& git push origin --tags ;
	echo '────────────────────────────────────────────────────────────────────────────────' ;
# ────────────────────────────────────────────────────────────────────────────────
snapshot: ## archives the repository and stores it under tmp/snapshots
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	- $(eval tmp=$(shell mktemp -d))
	- $(eval time=$(shell date +'%Y-%m-%d-%H-%M'))
	- $(eval snapshot_dir=$(CURDIR)/tmp/snapshots)
	- $(eval path=$(snapshot_dir)/$(time).tar.gz)
	- sync
	- $(MKDIR) $(snapshot_dir)
	- tar -C $(CURDIR) -cpzf $(tmp)/$(time).tar.gz .
	- mv $(tmp)/$(time).tar.gz $(path)
	- $(RM) $(tmp)
	- echo "*** snapshot created at $(path)"
	echo '────────────────────────────────────────────────────────────────────────────────' ;
#  ╭──────────────────────────────────────────────────────────╮
#  │                       meta targets                       │
#  ╰──────────────────────────────────────────────────────────╯
dep: --vale --fd ## a 'meta' target that runs all targets used for bootrapinng development environment
