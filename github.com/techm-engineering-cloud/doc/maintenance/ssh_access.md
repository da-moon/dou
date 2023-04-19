# Accessing servers using SSH

All servers are deployed to private subnets with the exception of bastion servers. Bastion servers are assigned a public IP address, so they can be used as a proxy to access servers in private subnets.

The private SSH key of the servers is stored in AWS Secrets Manager with the name `[installation_prefix-]<app_name>-key.pem`. For example, for TeamCenter servers the default key name is `tc-key.pem`.

Once you download the private SSH key you can access servers in the private subnet with these commands:

```
# These two commands are only needed to run once
chmod 400 tc-key.pem
ssh-add tc-key.pem

ssh -J <bastion host> <remote host>
```

The default user for the servers is `ubuntu`.

