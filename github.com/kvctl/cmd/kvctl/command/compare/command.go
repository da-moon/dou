package compare

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"strings"

	flags "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/flags"
	vault "github.com/DigitalOnUs/kvctl/internal/vault"
	version "github.com/DigitalOnUs/kvctl/internal/version"
	logger "github.com/da-moon/go-logger"
	"github.com/kylelemons/godebug/pretty"

	cli "github.com/mitchellh/cli"
)

type Command struct {
	logFilter logger.LevelFilter
	logger    *log.Logger
	args      []string
	UI        cli.Ui
}

type kv2secret struct {
	Data     interface{} `json:"data"`
	Metadata struct {
		CreatedTime    string      `json:"created_time"`
		CustomMetadata interface{} `json:"custom_metadata"`
		DeletionTime   string      `json:"deletion_time"`
		Destroyed      bool        `json:"destroyed"`
		Version        int         `json:"version"`
	} `json:"metadata"`
}

type RunInfo struct {
	ToolVersion       version.BuildInformation
	SourcePath        string
	SourceEngine      string
	DestinationPath   string
	DestinationEngine string
	RunTime           string
	RunUser           string
	VaultLoginMeta    map[string]interface{}
	ReadMe            string
}

var _ cli.Command = &Command{}

// Run ...
func (c *Command) Run(args []string) int {
	const entrypoint = "compare"
	c.args = args
	c.UI = &cli.PrefixedUi{
		OutputPrefix: "",
		InfoPrefix:   "",
		ErrorPrefix:  "",
		Ui:           c.UI,
	}
	cmdFlags := flag.NewFlagSet(entrypoint, flag.ContinueOnError)
	cmdFlags.Usage = func() { c.UI.Info(c.Help()) }
	vaultCA := flags.VaultCAFlag(cmdFlags)
	vaultPublicKey := flags.VaultPublicKeyFlag(cmdFlags)
	vaultPrivateKey := flags.VaultPrivateKeyFlag(cmdFlags)
	vaultNamespace := flags.VaultNamespaceFlag(cmdFlags)
	destVaultNamespace := flags.DestinationVaultNamespaceFlag(cmdFlags)
	mount := flags.MountPoint(cmdFlags)
	destMount := flags.DestinationMountPoint(cmdFlags)
	logLevel := flags.LogLevelFlag(cmdFlags)
	vaultAddress := flags.VaultAddressFlag(cmdFlags)
	destVaultAddress := flags.DestinationVaultAddressFlag(cmdFlags)
	vaultToken := flags.VaultTokenFlag(cmdFlags)
	destVaultToken := flags.DestinationVaultTokenFlag(cmdFlags)
	roleID := flags.VaultRoleIDFlag(cmdFlags)
	secretID := flags.VaultSecretIDFlag(cmdFlags)
	destRoleID := flags.DestinationVaultDestRoleIDFlag(cmdFlags)
	destSecretID := flags.DestinationVaultDestSecretIDFlag(cmdFlags)
	kvv2 := flags.SrcKVV2(cmdFlags)
	destkvv2 := flags.DestKVV2(cmdFlags)
	err := cmdFlags.Parse(c.args)
	if err != nil {
		return 1
	}

	if len(*mount) == 0 {
		c.UI.Error("vault mount point is required")
		return 1
	}
	if len(*destMount) == 0 {
		*destMount = *mount
	}

	logGate, _, _ := c.setupLoggers(*logLevel)
	c.UI.Warn("This tool uses threading so data may appear in an order different from what appears in Vault...")
	c.UI.Warn("Log data will now stream in no particular order:\n")
	logGate.Flush()
	l := logger.NewWrappedLogger(c.logger)

	backend := vault.New(l,
		vault.WithAddress(*vaultAddress),
		vault.WithMount(*mount),
		vault.LogOps(),
		vault.WithToken(*vaultToken),
	)
	backendDest := vault.New(l,
		vault.WithAddress(*vaultAddress),
		vault.WithMount(*destMount),
		vault.LogOps(),
		vault.WithToken(*destVaultToken),
	)
	parsedArgs := cmdFlags.Args()
	if len(parsedArgs) < 2 {
		c.UI.Error("cp operation needs '<source>' and '<destination>' as arguments")
		return 1
	}
	if len(*destVaultAddress) != 0 {
		backend.Configure(vault.WithAddress(*destVaultAddress))
	}
	if *kvv2 {
		backend.Configure(vault.VersionTwo())
	} else {
		backend.Configure(vault.VersionOne())
	}
	if len(*vaultCA) != 0 {
		backend.Configure(vault.WithCACertificate(*vaultCA))
	}
	if len(*vaultPublicKey) != 0 {
		backend.Configure(vault.WithClientCert(*vaultPublicKey))
	}
	if len(*vaultPrivateKey) != 0 {
		backend.Configure(vault.WithClientKey(*vaultPrivateKey))
	}
	if len(*vaultNamespace) != 0 {
		backend.Configure(vault.WithNamespace(*vaultNamespace))
	}
	err = backend.Init()
	if err != nil {
		c.UI.Error(fmt.Sprintf("could not establish connection to Vault server at '%v' due to err : %v", *vaultAddress, err))
		return 1
	}
	if len(*vaultCA) != 0 {
		backendDest.Configure(vault.WithCACertificate(*vaultCA))
	}
	if len(*vaultPublicKey) != 0 {
		backendDest.Configure(vault.WithClientCert(*vaultPublicKey))
	}
	if len(*vaultPrivateKey) != 0 {
		backendDest.Configure(vault.WithClientKey(*vaultPrivateKey))
	}
	if len(*destVaultNamespace) != 0 {
		backendDest.Configure(vault.WithNamespace(*destVaultNamespace))
		// ns = *destVaultNamespace
	}
	if *destkvv2 {
		backendDest.Configure(vault.VersionTwo())
	} else {
		backendDest.Configure(vault.VersionOne())
	}
	err = backendDest.Init()
	if err != nil {
		c.UI.Error(
			fmt.Sprintf("could not establish connection to Vault server at '%v' due to err : %v", *vaultAddress, err),
		)
		return 1
	}

	if len(*roleID) != 0 && len(*secretID) != 0 && *roleID != "root" && *secretID != "root" {
		if err := backend.AppRoleAuth(context.Background(), *roleID, *secretID); err != nil {
			c.UI.Error(err.Error())
			return 1
		}
	}
	if len(*destRoleID) != 0 && len(*destSecretID) != 0 && *destRoleID != "root" && *destSecretID != "root" {
		if err := backendDest.AppRoleAuth(context.Background(), *destRoleID, *destSecretID); err != nil {
			c.UI.Error(err.Error())
			return 1
		}
	}

	recursive := backend.Recursive()
	recursiveDest := backendDest.Recursive()
	source := parsedArgs[0]
	destination := parsedArgs[1]

	data, err := recursive.Fetch(source, destination)
	if err != nil {
		c.UI.Error(fmt.Sprintf("Fetch err:\n%v", err))
		return 1
	}

	var prettyData []map[string]kv2secret
	for _, v := range data {
		for k, l := range v {
			var result kv2secret
			json.Unmarshal(l.Value, &result)
			prettyData = append(prettyData, map[string]kv2secret{k: result})
		}
	}

	data2, err := recursiveDest.Fetch(source, destination)
	if err != nil {
		c.UI.Error(fmt.Sprintf("Fetch err:\n%v", err))
		return 1
	}

	var prettyData2 []map[string]kv2secret
	for _, v := range data2 {
		for k, l := range v {
			var result kv2secret
			json.Unmarshal(l.Value, &result)
			prettyData2 = append(prettyData2, map[string]kv2secret{k: result})
		}
	}

	for _, v := range prettyData {
		for k, l := range v {
			fmt.Println("Key: ", k)
			dstIndex, err := findInMapSlice(prettyData2, k)
			if err != nil {
				c.UI.Error(fmt.Sprintf("Key from source does not exist on destination:\n%v", err))
				continue
			}
			if l.Metadata.CreatedTime != "" {
				l.Metadata.CreatedTime = ""
			}
			if l.Metadata.Version != 0 {
				l.Metadata.Version = 0
			}
			destSecret := prettyData2[dstIndex][k]
			if destSecret.Metadata.CreatedTime != "" {
				destSecret.Metadata.CreatedTime = ""
			}
			if destSecret.Metadata.Version != 0 {
				destSecret.Metadata.Version = 0
			}
			result := pretty.Compare(l, destSecret)
			if result != "" {
				fmt.Println("Mismatch detected at path, details are:\n", result)
			} else {
				fmt.Println("\tSource and Destination are identical!")
			}
		}
	}

	return 0
}

func findInMapSlice(input []map[string]kv2secret, search string) (int, error) {
	for k, v := range input {
		for id := range v {
			if id == search {
				return k, nil
			}
		}
	}
	return -1, fmt.Errorf("invalid search string: %s", search)
}

// Synopsis ...
func (c *Command) Synopsis() string {
	return "compares entries from one path to another."
}

// Help ...
func (c *Command) Help() string {
	helpText := `
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
`
	return strings.TrimSpace(helpText)
}

func (c *Command) setupLoggers(logLevel string) (*logger.GatedWriter, *logger.LogWriter, io.Writer) {
	logGate := logger.NewGatedWriter(os.Stderr)
	c.logFilter = logger.NewLevelFilter(
		logger.WithMinLevel(strings.ToUpper(logLevel)),
		logger.WithWriter(logGate),
	)
	// Create a log writer, and wrap a logOutput around it
	logWriter := logger.NewLogWriter(512)
	logOutput := io.MultiWriter(c.logFilter, logWriter)
	// Create a logger
	c.logger = log.New(logOutput, "", log.LstdFlags)
	return logGate, logWriter, logOutput
}
