package flags

import (
	"flag"
	"os"
)

func MountPoint(f *flag.FlagSet) *string {
	var result string
	return f.String("mount", result,
		"vault kv secrets engine mount point.")
}
func DestinationMountPoint(f *flag.FlagSet) *string {
	var result string
	return f.String("dest-mount", result,
		"vault kv secrets engine mount point.")
}
func SrcKVV2(f *flag.FlagSet) *bool {
	var result bool
	return f.Bool("src-kvv2", result, "kv version 2")
}
func DestKVV2(f *flag.FlagSet) *bool {
	var result bool
	return f.Bool("dest-kvv2", result, "kv version 2")
}
func ReportFlag(f *flag.FlagSet) *bool {
	var result bool
	return f.Bool("no-report", result, "disable report secret")
}
func PromptFlag(f *flag.FlagSet) *bool {
	var result bool
	return f.Bool("no-prompt", result, "disable report secret")
}

// LogLevelFlag ...
func LogLevelFlag(f *flag.FlagSet) *string {
	result := os.Getenv("KVCTL_LOG_LEVEL")
	if result == "" {
		result = "INFO"
	}
	return f.String("log-level", result,
		"flag used to indicate log level")
}

// VaultCAFlag ...
func VaultCAFlag(f *flag.FlagSet) *string {
	result := os.Getenv("VAULT_CACERT")

	return f.String("vault-ca-cert", result,
		`Path on the local disk to a single PEM-encoded CA certificate to verify
		the Vault server's SSL certificate.`)
}

// VaultPublicKeyFlag ...
func VaultPublicKeyFlag(f *flag.FlagSet) *string {
	result := os.Getenv("VAULT_CLIENT_CERT")

	return f.String("vault-client-cert", result,
		`Path on the local disk to a single PEM-encoded CA certificate to use
		for TLS authentication to the Vault server.`)
}

// VaultPrivateKeyFlag ...
func VaultPrivateKeyFlag(f *flag.FlagSet) *string {
	result := os.Getenv("VAULT_CLIENT_KEY")
	return f.String("vault-client-key", result,
		`Path on the local disk to a single PEM-encoded private key matching the
		client certificate from vault-client-cert.`)
}

// VaultAddressFlag ...
func VaultAddressFlag(f *flag.FlagSet) *string {
	result := os.Getenv("VAULT_ADDR")
	if result == "" {
		result = "http://127.0.0.1:8200"
	}

	return f.String("vault-addr", result,
		"Address of the Vault server.")
}

// DestinationVaultAddressFlag ...
func DestinationVaultAddressFlag(f *flag.FlagSet) *string {
	result := os.Getenv("DEST_VAULT_ADDR")
	if result == "" {
		result = os.Getenv("VAULT_ADDR")
		if result == "" {
			result = "http://127.0.0.1:8200"
		}
	}

	return f.String("dest-vault-addr", result,
		"Address of the Vault server.")
}

// VaultTokenFlag ...
func VaultTokenFlag(f *flag.FlagSet) *string {
	result := os.Getenv("VAULT_TOKEN")
	if result == "" {
		result = "root"
	}
	return f.String("vault-token", result,
		"vault token used to interact with vault server")
}
func DestinationVaultTokenFlag(f *flag.FlagSet) *string {
	result := os.Getenv("DEST_VAULT_TOKEN")
	if result == "" {
		result = "root"
	}
	return f.String("dest-vault-token", result,
		"vault token used to interact with vault server")
}
func VaultRoleIDFlag(f *flag.FlagSet) *string {
	result := os.Getenv("VAULT_ROLE_ID")
	if result == "" {
		result = "root"
	}
	return f.String("vault-role-id", result,
		"vault role id to authenticater")
}
func VaultSecretIDFlag(f *flag.FlagSet) *string {
	result := os.Getenv("VAULT_SECRET_ID")
	if result == "" {
		result = "root"
	}
	return f.String("vault-secret-id", result,
		"vault secret id to authenticate")
}
func DestinationVaultDestRoleIDFlag(f *flag.FlagSet) *string {
	result := os.Getenv("DEST_VAULT_ROLE_ID")
	if result == "" {
		result = "root"
	}
	return f.String("dest-vault-role-id", result,
		"vault role id to authenticate")
}
func DestinationVaultDestSecretIDFlag(f *flag.FlagSet) *string {
	result := os.Getenv("DEST_VAULT_SECRET_ID")
	if result == "" {
		result = "root"
	}
	return f.String("dest-vault-secret-id", result,
		"vault secret id to authenticate")
}
func VaultNamespaceFlag(f *flag.FlagSet) *string {
	result := os.Getenv("VAULT_NAMESPACE")
	return f.String("vault-namespace", result,
		"vault namespace")
}

func DestinationVaultNamespaceFlag(f *flag.FlagSet) *string {
	result := os.Getenv("DESTINATION_VAULT_NAMESPACE")
	return f.String("dest-vault-namespace", result,
		"destination vault namespace")
}
