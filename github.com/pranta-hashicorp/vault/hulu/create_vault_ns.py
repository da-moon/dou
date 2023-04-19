#!/usr/bin/env python
import sys
import os
import requests
import json
import pdb

def check_usage():
# Check for the correct number of arguments. If no argument is specified, error out.
  if len(sys.argv) <= 1:
    print ("Error: Too few arguments.")
    print ("Usage: python ", sys.argv[0], " <vault-namespace-name>")
    sys.exit()

  if os.getenv("VAULT_ADDR") is None:
    print ("Error: Environment variable VAULT_ADDR not set.")
    print ("Please set VAULT_ADDR prior to running this script")
    sys.exit()

  if os.getenv("VAULT_TOKEN") is None:
    print ("Error: Environment variable VAULT_TOKEN not set.")
    print ("Please set VAULT_TOKEN prior to running this script")
    sys.exit()
  return

check_usage()

vault_namespace_name = sys.argv[1]

vault_addr = os.environ['VAULT_ADDR']

vault_token = os.environ['VAULT_TOKEN']

hdrs = {'X-Vault-Token': vault_token } 

url = vault_addr + '/v1/sys/namespaces/' + vault_namespace_name

payload = {}

r = requests.post(url, data=json.dumps(payload), headers=hdrs)

print(r.text)

