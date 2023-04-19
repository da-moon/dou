# Vault KVCTL

## Synopsis

The `kvctl` tool provides a way to recursively interact with Hashicorp Vault KV
stores, with recursive read, list, copy and compare commands available.

### Copy Command Usage

The `cp` command copies entries recursively from one folder path to another. By
default, it will prompt the user if there overwrites will occur. This behaviour
can be disabled so that the tool can be leveraged in a pipeline.

```md
Usage: kvctl cp [options] <source> <destination>

  copies entries from one path to another.

  this operation is recursive by nature

Options:
  -log-level=INFO                   Log level: WARN/INFO/DEBUG/TRACE/ERROR
                                    Default: 'INFO' or 'KVCTL_LOG_LEVEL' env var

  -mount=certificates               KV secret engine mount path

  -dest-mount=ca                    KV secret engine destination mount path

  -vault-token=root                 Agent's token to communicate with Vault
                                    Default: 'VAULT_TOKEN' env variable

  -dest-vault-token=root            Agent's token to communicate with Vault
                                    Default: 'DEST_VAULT_TOKEN' env variable

  -vault-namespace=default          Vault Namespace to target
                                    Default: 'VAULT_NAMESPACE' env variable

  -dest-vault-namespace=ns          Vault namespace on destination if any
                                    Default: 'DEST_VAULT_NAMESPACE' env variable

  -vault-ca-cert=/path/to/ca        CA used in Vault Cluster.
                                    Default: 'VAULT_CACERT' env variable

  -vault-client-cert=/path/to/cert  Client cert for communication with Vault
                                    Default: 'VAULT_CLIENT_CERT' env variable

  -vault-client-key=/path/to/key    Client key for communication with Vault
                                    Default: 'VAULT_CLIENT_KEY' env variable

  -vault-addr=<ADDRESS>             A single node in vault cluster.
                                    Default: 'VAULT_ADDR' env variable

  -dest-vault-addr=<ADDRESS>        A single node in vault cluster.
                                    Default: 'DEST_VAULT_ADDR' env variable

  -vault-role-id=<role-id>          Vault Source RoleID to authenticate.
                                    Default: 'VAULT_ROLE_ID' env variable

  -vault-secret-id=<secret-id>      Vault Source SecretID to authenticate.
                                    Default: 'VAULT_SECRET_ID' env variable

  -dest-vault-role-id=<role-id>     Vault Destination RoleID to authenticate.
                                    Default: 'DEST_VAULT_ROLE_ID' env variable

  -dest-vault-secret-id=<secret-id> Vault Destination SecretID to authenticate.
                                    Default: 'DEST_VAULT_SECRET_ID' env variable

  -kvv2                             Bypass preflight checks in kv mounts to
                                    determine kv version.
                                    Default: version 2 set

  -no-report                        Do not place a secret at
                                    <destination>/._kvctl containing report info
                                    Default: false
  -no-prompt                        Do not interactively prompt when writing
                                    writing secrets to a destination that has
                                    data present.
                                    Default: false
```

### Compare Command Usage

There is also a `compare` sub-command that can be used to validate the copy
operation was successful. If there are any variances, the output will highlight
the path and the part of the secret that has differences. It has all the same
flags as above, with the exception of the `-no-report` flag. The `compare`
sub-command does not have any ability to write data and is, therefore, safe to
run if you have any doubts about the `cp` operation, especially if the process
was interrupted before completion. See below for a sample command.

```md
Usage: kvctl compare [options] <source> <destination>

  Compares entries from one path to another. Does not evaluate any "extra"
  entries that may be present on the destination.

  This operation is recursive by nature.

Options:
  -log-level=INFO                   Log level: WARN/INFO/DEBUG/TRACE/ERROR
                                    Default: 'INFO' or 'KVCTL_LOG_LEVEL' env var

  -mount=certificates               KV secret engine mount path

  -dest-mount=ca                    KV secret engine destination mount path

  -vault-token=root                 Agent's token to communicate with Vault
                                    Default: 'VAULT_TOKEN' env variable

  -dest-vault-token=root            Agent's token to communicate with Vault
                                    Default: 'DEST_VAULT_TOKEN' env variable

  -vault-namespace=default          Vault Namespace to target
                                    Default: 'VAULT_NAMESPACE' env variable

  -dest-vault-namespace=ns          Vault namespace on destination if any
                                    Default: 'DEST_VAULT_NAMESPACE' env variable

  -vault-ca-cert=/path/to/ca        CA used in Vault Cluster.
                                    Default: 'VAULT_CACERT' env variable

  -vault-client-cert=/path/to/cert  Client cert for communication with Vault
                                    Default: 'VAULT_CLIENT_CERT' env variable

  -vault-client-key=/path/to/key    Client key for communication with Vault
                                    Default: 'VAULT_CLIENT_KEY' env variable

  -vault-addr=<ADDRESS>             A single node in vault cluster.
                                    Default: 'VAULT_ADDR' env variable

  -dest-vault-addr=<ADDRESS>        A single node in vault cluster.
                                    Default: 'DEST_VAULT_ADDR' env variable

  -vault-role-id=<role-id>          Vault Source RoleID to authenticate.
                                    Default: 'VAULT_ROLE_ID' env variable

  -vault-secret-id=<secret-id>      Vault Source SecretID to authenticate.
                                    Default: 'VAULT_SECRET_ID' env variable

  -dest-vault-role-id=<role-id>     Vault Destination RoleID to authenticate.
                                    Default: 'DEST_VAULT_ROLE_ID' env variable

  -dest-vault-secret-id=<secret-id> Vault Destination SecretID to authenticate.
                                    Default: 'DEST_VAULT_SECRET_ID' env variable

  -kvv2                             Bypass preflight checks in kv mounts to
                                    determine kv version.
                                    Default: version 2 set

```

### Command Examples

```sh
    export VAULT_ADDR=http://vault:8200
    export DEST_VAULT_ADDR=http://vault:8200
    bin/linux/kvctl cp -log-level=TRACE \
                   -mount=secret \
                   -dest-mount=kv2 \
                   godzilla.dev/ \
                   new/

    bin/linux/kvctl compare -log-level=TRACE \
                   -mount=element2 \
                   -vault-namespace=root \
                   -vault-token=root \
                   -dest-mount=migrate \
                   -dest-vault-namespace=root \
                   -dest-vault-token=root godzilla.dev/ new/

    bin/linux/kvctl rlist -mount=element2 \
                    -vault-namespace=root \
                    -vault-token=root \
                    /

    bin/linux/kvctl rread -mount=element2 \
                    -vault-namespace=root \
                    -vault-token=root \
                    /
```

## How to test for developers

1. Set environment variable `VAULT_LICENSE` with a currently valid Vault Enterprise license.
2. run docker-compose file located under `.devcontainer/` folder.
3. run docker log --follow for `vault` container.
  2.1. copy unseal key
4. run docker exec into the `devcontainer-kvctl-1` container and run the following:

```console
$ vault operator unseal                       # unseal vault to initialize it
                                              # use unseal key from step 2.1
$ cd /workspace                               # navigate to correct folder
$ make build                                  # build kvctl binary
$ bash contrib/mock/mock-non-namespace-kv.sh  # add random content to vault
$ . contrib/mock/non-root-mock.sh             # create non-root token in ${kv_admin_token}
```

  3.1. review vault KV data and namespaces

  3.2. run the following command:

```console
    # source value will be / in order to copy everything inside element1 kv engine
    # destination value will be / in order to put everything without any extra path

    # source could be any key element that exists inside element1 kv engine
    # destination could anything will append the name at the begging of the path
    # e.g. kvctl cp -mount=element1 -dest-vault-namespace=ns_element1 -log-level=TRACE secret1 test
    # result will be: test/secret1 and will be stored under ns_element1 namespace and inside element1 kv engine

    # IF you want to test any of these commands with a non-root token, you can
    # prefix the command with `VAULT_TOKEN="${kv_admin_token}" ` (the trailing space is important)

    # Using Token Auth

    $ bin/linux/kvctl cp -log-level=TRACE \
                   -mount=ci_kv \
                   -vault-namespace=namespace_test \
                   -vault-token=<token with privileges to access endpoints> \
                   -dest-mount=ci \
                   -dest-vault-namespace=godzilla \
                   -dest-vault-token=<token with privileges to access endpoints> <source-path> <dest-path>

    # Using AppRole Auth

    export VAULT_ADDR=<vault address>
    export DEST_VAULT_ADDR=<destination vault address> (optional if not present destination address will use VAULT_ADDR)

    $  bin/linux/kvctl cp \
          -log-level=TRACE \
          -mount=np_kv \
          -vault-namespace=namespace_test \
          -vault-role-id=c94ffecb-2e77-0448-b3c7-e0316671f959 \
          -vault-secret-id=c04e11ec-a1f6-4e5c-719c-3b1c760c20a2 \
          -dest-mount=np \
          -dest-vault-namespace=godzilla \
          -dest-vault-role-id=48c79a78-9004-eada-12c0-1746c5494fe0 \
          -dest-vault-secret-id=afe84aa4-4fad-295f-88ca-51ad49528f3d \
          -kvv2 \
          test migrated/
```
