## Environments folder

This folder contains variables that are specific to each environment. Folder structure:

```
environments/
  bootstrap.tfvars                   # Contains variables used for the full Engineering in Cloud installation.
  teamcenter/                        # Used only when installing TeamCenter software.
    common.tfvars                    # Variables that are common for all TeamCenter environments.
    env1/                            # Each subfolder inside "teamcenter" corresponds to a separate TeamCenter environment.
      env.tfvars                     # Variables specific for a TeamCenter environment.
      quick_deploy_configuration.xml # TeamCenter quick deploy configuration file.
    env2/
      env.tfvars
      quick_deploy_configuration.xml
```

You can find a complete example of the contents of this folder in `doc/environments_example`.
