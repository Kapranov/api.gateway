V ?= @
APP_NAME_SERVER ?= `grep 'app:' apps/gateway/mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_NAME_CORE ?= `grep 'app:' apps/core/mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN_SERVER ?= `grep 'version:' apps/gateway/mix.exs | cut -d '"' -f2`
APP_VSN_CORE ?= `grep 'version:' apps/core/mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`
SERVER_VERSION ?= '0.1'
TZ ?= 'Pacific/Honolulu'
SHELL := /usr/bin/env bash
ERLSERVICE := $(shell pgrep beam.smp)
NUM := {1..4}

ELIXIR = elixir
MIX=mix
GIT=git

VERSION = $(shell git describe --tags --abbrev=0 | sed 's/^v//')

NO_COLOR=\033[0;0m
INFO_COLOR=\033[2;32m
SHOW_COLOR=\033[1;5;31m
STAT_COLOR=\033[2;33m

help:
													@echo "$(APP_NAME_SERVER):$(APP_VSN_SERVER)-$(BUILD)"
													@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

git-%:
													$(V)$(GIT) add .
													$(V)$(GIT) commit -m "$(@:git-%=%)"

git_log:
													$(V)$(GIT) log -p -$(NUM)

git_pretty:
													$(v)$(GIT) log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

git_log_line:
													$(v)$(GIT) logline

git_short:
													$(V)$(GIT) log --graph --abbrev-commit --decorate --date=relative --all

git_tree:
													$(V)$(GIT) tree

git_stree:
													$(V)$(GIT) stree

git_vtree:
													$(V)$(GIT) vtree

pull:
													$(V)$(GIT) pull

log:
													$(V)clear
													$(V)echo -e "\n"
													$(V)echo -e "\t$(SHOW_COLOR) There are commits:$(NO_COLOR) \n"
													$(V)$(GIT) log --pretty="format:%Cblue%hash|%ae|%an|%Cred%s"
													$(V)echo -e "\n"

kill:
													$(V)echo "Checking to see if Erlang process exists:"
													$(V)if [ "$(ERLSERVICE)" ]; then killall beam.smp && echo "Running Erlang Service Killed"; else echo "No Running Erlang Service!"; fi

clean:
													$(V)$(MIX) deps.clean --all
													$(V)$(MIX) do clean
													$(V)rm -fr _build/ ./deps/

install.erlexec:
													$(V)cd deps/erlexec && make

packs:
													$(V)$(MIX) deps.get
													$(V)$(MIX) deps.update --all
													$(V)$(MIX) deps.get

outdated:
													$(V)$(MIX) hex.outdated

recovery:
													$(V)$(MIX) deps.compile
													$(V)$(MIX) compile
swagger:
													$(V)$(MIX) phx.swagger.generate
credo:
													$(V)$(MIX) credo

test:
													$(V)clear
													$(V)echo -en "\n\t$(INFO_COLOR)Run server tests:$(NO_COLOR)\n\n"
													$(V)$(MIX) test --color

run: kill clean packs
													$(V)echo -en "\n\t$(STAT_COLOR) Run server https://localhost:$(NO_COLOR)$(INFO_COLOR)4001$(NO_COLOR)\n"
													$(V)iex -S mix phx.server

halt: kill
													$(V)echo -en "\n\t$(STAT_COLOR) Run server https://localhost:$(NO_COLOR)$(INFO_COLOR)4001$(NO_COLOR)\n"
													$(V)$(MIX) run --no-halt

start: kill clean packs
													$(V)echo -en "\n\t$(STAT_COLOR) Run server https://localhost:$(NO_COLOR)$(INFO_COLOR)4001$(NO_COLOR)\n"

up: kill
													$(V)mix run --no-halt

compile: kill clean packs install.erlexec
													$(V)$(MIX) compile

all: test credo start

.PHONY: help git-% all clean compile_dev compile_test credo halt kill log packs pull run start swagger test up
