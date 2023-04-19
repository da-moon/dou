#!/usr/bin/env bash

kv_admin_token=$(vault write -format=json auth/token/create-orphan policies=kv-admin | jq -r .auth.client_token)
export kv_admin_token
