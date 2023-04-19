package rlist

import (
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"strings"

	flags "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/flags"
	vault "github.com/DigitalOnUs/kvctl/internal/vault"
	"github.com/da-moon/go-codec"
	logger "github.com/da-moon/go-logger"

	cli "github.com/mitchellh/cli"
)

type Command struct {
	logFilter logger.LevelFilter
	logger    *log.Logger
	args      []string
	UI        cli.Ui
}

var _ cli.Command = &Command{}

// Run ...
func (c *Command) Run(args []string) int {
	const entrypoint = "rlist"
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
	mount := flags.MountPoint(cmdFlags)
	logLevel := flags.LogLevelFlag(cmdFlags)
	vaultAddress := flags.VaultAddressFlag(cmdFlags)
	vaultToken := flags.VaultTokenFlag(cmdFlags)
	prefix := KeyPrefixFlag(cmdFlags)
	flat := FlatFlag(cmdFlags)
	err := cmdFlags.Parse(c.args)
	if err != nil {
		return 1
	}
	if len(*mount) == 0 {
		c.UI.Error("vault mount point is required")
		return 1
	}

	logGate, _, _ := c.setupLoggers(*logLevel)
	c.UI.Warn("")
	c.UI.Warn("Log data will now stream in as it occurs:\n")
	logGate.Flush()
	l := logger.NewWrappedLogger(c.logger)
	backend := vault.New(l,
		vault.WithAddress(*vaultAddress),
		vault.VersionOne(),
		vault.WithMount(*mount),
		vault.LogOps(),
		vault.WithToken(*vaultToken),
	)

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
	recursive := backend.Recursive()
	if *flat {
		type response struct {
			Keys []string `json:"keys"`
		}
		list, err := recursive.List(*prefix)
		if err != nil {
			c.UI.Error(fmt.Sprintf("err:%v", err))
			return 1
		}
		result, err := codec.EncodeJSONWithIndentation(response{
			Keys: list,
		})
		if err != nil {
			c.UI.Error(fmt.Sprintf("err:%v", err))
			return 1
		}
		c.UI.Output(string(result))
		return 0
	}
	tree, err := recursive.Tree(*prefix)
	if err != nil {
		c.UI.Error(fmt.Sprintf("err:%v", err))
		return 1
	}
	c.UI.Output(tree)
	return 0
}

// Synopsis ...
func (c *Command) Synopsis() string {
	return "recursively lists all keys under a certain prefix in Vault KV."
}

// Help ...
func (c *Command) Help() string {
	helpText := `
Usage: kvctl rlist [options]

  recursively list all keys attached to a value in
  a certain path of a KV engine in Vault.
  
  By default, it returns a tree view.

Options:
  -mount=certificates                   KV secret engine mount path

  -key-prefix=foo                       key-prefix for recursive listing
                                        mount vault as file system.

  -flat                                 returns a json result containing only a flat list of entry keys
                                        Default: False
										
  -log-level=INFO                       log level
                                        Default: 'INFO' or 'KVCTL_LOG_LEVEL' env variable

  -vault-token=root                     Agent's token to communicate with Vault cluster
                                        Default: 'VAULT_TOKEN' env variable

  -vault-namespace=default          	vault namespace to target
                                        Default: 'VAULT_NAMESPACE' env variable

  -vault-ca-cert=/path/to/ca            CA used in Vault Cluster.
                                        Default: 'VAULT_CACERT' env variable

  -vault-client-cert=/path/to/cert      Client certificate for comminucating with Vault Cluster.
                                        Default: 'VAULT_CLIENT_CERT' env variable

  -vault-client-key=/path/to/key        Client key comminucating with Vault Cluster.
                                        Default: 'VAULT_CLIENT_KEY' env variable

  -vault-addr=http://127.0.0.1:8200     A single node in vault cluster.
                                        Default: 'VAULT_ADDR' env variable
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
