#!/usr/bin/env bash
ROOT="$(git rev-parse --show-toplevel)"
# [ TODO ] @damoon: exclude test files.
[ -z "$(command -v golangci-lint 2>/dev/null)" ] && exit 1
staged=("$(git -C "${ROOT}" diff --name-only --staged '*.go')")
staged=("${staged[@]/#/${ROOT}\/}")
if [ -r "${ROOT}/.golangci.yml" ]; then
  golangci-lint run --fix --config "${ROOT}/.golangci.yml" "${staged[@]}"
else
  golangci-lint run --fix --fast "${staged[@]}"
fi
