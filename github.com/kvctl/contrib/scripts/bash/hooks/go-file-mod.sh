#!/usr/bin/env bash

git ls-files --stage '*.go' | while read -r mode _ _ file_path; do
  case $mode in
    *644) git update-index --chmod=644 -- "$file_path" ;;
    *) ;;
  esac
done
