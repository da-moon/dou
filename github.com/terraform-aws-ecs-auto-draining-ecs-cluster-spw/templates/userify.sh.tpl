#!/bin/bash

# Userify shim Installation
# Company: Corvesta
# Project: ECS

curl -1 -sS "https://static.userify.com/installer.sh" | \
    api_key="${api_key}" \
    api_id="${api_id}" \
    company_name="Corvesta" \
    project_name="ECS" \
    static_host="static.userify.com" \
    shim_host="configure.userify.com" \
    self_signed=0 \
    sudo -sbE
