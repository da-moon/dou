package rread

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"strings"

	flags "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/flags"
	strutils "github.com/DigitalOnUs/kvctl/internal/strutils"
	vault "github.com/DigitalOnUs/kvctl/internal/vault"
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
	const entrypoint = "rread"
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
	encResult, err := recursive.Read(*prefix)
	if err != nil {
		c.UI.Error(fmt.Sprintf("err:%v", err))
		return 1
	}
	type response struct {
		Key   string      `json:"key"`
		Value interface{} `json:"value"`
	}
	resp := make([]response, 0)
	for _, v := range encResult {
		out := make(map[string]interface{})
		r := bytes.NewReader(v.Value)
		dec := json.NewDecoder(r)
		dec.UseNumber()
		err = dec.Decode(&out)
		if err != nil {
			// [ NOTE ] skipping warning for unexpected EOF
			if !strings.Contains(err.Error(), "unexpected EOF") {
				c.UI.Warn(fmt.Sprintf("err : %v", err))
			}
			continue
		}
		resp = append(resp, response{
			Key:   v.Key,
			Value: out["data"],
		})
	}

	var buffer bytes.Buffer
	err = strutils.PrettyEncode(resp, &buffer)
	if err != nil {
		log.Fatal(err)
	}
	c.UI.Output(buffer.String())

	// result, err := json.Marshal(resp)
	// if err != nil {
	// 	c.UI.Error(fmt.Sprintf("err:%v", err))
	// 	return 1
	// }
	// c.UI.Output(string(result))
	return 0
}

// Synopsis ...
func (c *Command) Synopsis() string {
	return "recursively reads all entry values."
}

// Help ...
func (c *Command) Help() string {
	helpText := `
Usage: kvctl rread [options]

  recursively reads all entries under a certain path
  of a KV engine in Vault and returns values as an array
  of JSON objects

Options:
  -mount=certificates                   KV secret engine mount path
 
  -key-prefix=foo                       key-prefix for recursive reading
  
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
