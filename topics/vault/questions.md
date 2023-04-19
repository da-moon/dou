## Vault Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Questions

- **Basic questions**:
    - What is the Vault?
        + Vault is a tool for securely accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, or certificates.<br>Vault provides a unified interface to any secret, while providing tight access control and recording a detailed audit log.
    -  What are the Key Features of Vault?
        + Secure Secret Storage: Arbitrary key/value secrets can be stored in Vault. Vault encrypts these secrets prior to writing them to persistent storage, so gaining access to the raw storage isn’t enough to access your secrets. Vault can write to disk, Consul, and more.
        + Dynamic Secrets: Vault can generate secrets on-demand for some systems, such as AWS or SQL databases. For example, when an application needs to access an S3 bucket, it asks Vault for credentials, and Vault will generate an AWS keypair with valid permissions on demand. After creating these dynamic secrets, Vault will also automatically revoke them after the lease is up.
        + Data Encryption: Vault can encrypt and decrypt data without storing it. This allows security teams to define encryption parameters and developers to store encrypted data in a location such as SQL without having to design their own encryption methods.
        + Leasing and Renewal: All secrets in Vault have a lease associated with them. At the end of the lease, Vault will automatically revoke that secret. Clients are able to renew leases via built-in renew APIs.
        + Revocation: Vault has built-in support for secret revocation. Vault can revoke not only single secrets, but a tree of secrets, for example all secrets read by a specific user, or all secrets of a particular type. Revocation assists in key rolling as well as locking down systems in the case of an intrusion. https://www.vaultproject.io/docs/what-is-vault
    - All the leases associated with secrets will automatically be renewed and you don’t have to do anything. Is this True?
        + False. All secrets in Vault have a lease associated with them. At the end of the lease, Vault will automatically revoke that secret. Clients are able to renew leases via built-in renew APIs.
    -  How do you start the vault server in dev mode?
        + vault server -devYou can start Vault as a server in "dev" mode like so: vault server -dev. This dev-mode server requires no further setup, and your local vault CLI will be authenticated to talk to it.
    -  What is unsealing the Vault?
        + Unsealing is the process of obtaining the plaintext master key necessary to read the decryption key to decrypt the data, allowing access to the Vault.
    - When you start the Vault server in production. It is sealed by default. Is this true?
        + True.<br>When a Vault server is started, it starts in a sealed state. In this state, Vault is configured to know where and how to access the physical storage, but doesn't know how to decrypt any of it.
    - How does the Vault secret engine works?
    ![Vault Secrets Engine](https://github.com/DigitalOnUs/devops_interviews/blob/master/topics/vault/vault-secrets-engine.png)
    - How do you authenticate to Vault?
        + To authenticate with the CLI, vault login is used. This supports many of the built-in auth methods, for example: `vault login -method=github token=<token>`

- **Advance questions**:
    - What is the default address of the Vault in the development mode?
        + `http://127.0.0.1:8200`
    - You are developing an application and uses Vault. Your application is not in production yet and you want to do experiments with Vault. What is the easiest method to do that?
        ```
        Start Vault in dev mode
        vault server -dev
        ```
    - Bob has accounts in both Github and LDAP. Both Github and LDAP auth methods are enabled on the Vault server that he can authenticate using either one of his accounts. Although both accounts belong to Bob, there is no association between the two accounts to set some common properties. How do you solve this challenge?
        + Create an entity representing Bob, and associate aliases representing each of his accounts as the entity member. You can set additional policies and metadata on the entity level so that both accounts can inherit.<br>https://learn.hashicorp.com/tutorials/vault/identity
    - Why Vault’s transit secrets engine can be viewed as encryption as a service?
        + Vault's transit secrets engine handles cryptographic functions on data-in-transit. Vault doesn't store the data sent to the secrets engine, so it can also be viewed as encryption as a service.
    - How the transit secrets engine relieves the burden of proper encryption/decryption from application developers?
        + Although the transit secrets engine provides additional features (sign and verify data, generate hashes and HMACs of data, and act as a source of random bytes), its primary use case is to encrypt data. This relieves the burden of proper encryption/decryption from application developers and pushes the burden onto the operators of Vault.<br>The transit secrets engine enables security teams to fortify data during transit and at rest. So even if an intrusion occurs, your data is encrypted with AES-GCM with a 256-bit AES key or other supported key types. Even if an attacker were able to access the raw data, they would only have encrypted bits. This means attackers would need to compromise multiple systems before exfiltrating data.
    - What is the difference between cubbyhole and key/value secrets engine?
        + In Vault, the cubbyhole is your "locker". All secrets are namespaced under your token. If that token expires or is revoked, all the secrets in its cubbyhole are revoked as well.<br>It is not possible to reach into another token's cubbyhole even as the root user. This is an important difference between the cubbyhole and the key/value secrets engine. The secrets in the key/value secrets engine are accessible to any token for as long as its policy allows it.
    - Github is one of the Auth methods available. How do you enable the Github Auth method?
        + vault auth enable github