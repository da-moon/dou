package push

import (
	"context"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/DigitalOnUs/kvctl/cmd/kvctl/command/flags"
	vault "github.com/DigitalOnUs/kvctl/internal/vault"
	files "github.com/da-moon/go-files"
	logger "github.com/da-moon/go-logger"
	"github.com/da-moon/go-primitives"
	cli "github.com/mitchellh/cli"
	"github.com/palantir/stacktrace"
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
	const entrypoint = "push"
	c.args = args
	c.UI = &cli.PrefixedUi{
		OutputPrefix: "",
		InfoPrefix:   "",
		ErrorPrefix:  "",
		Ui:           c.UI,
	}
	cmdFlags := flag.NewFlagSet(entrypoint, flag.ContinueOnError)
	cmdFlags.Usage = func() { c.UI.Info(c.Help()) }
	var inputs []string
	cmdFlags.Var((*primitives.AppendSliceValue)(&inputs), "input", "file or directory to store in vault")
	regex := RegexFlag(cmdFlags)
	vaultCA := flags.VaultCAFlag(cmdFlags)
	vaultPublicKey := flags.VaultPublicKeyFlag(cmdFlags)
	vaultPrivateKey := flags.VaultPrivateKeyFlag(cmdFlags)
	vaultNamespace := flags.VaultNamespaceFlag(cmdFlags)
	logLevel := flags.LogLevelFlag(cmdFlags)
	mount := flags.MountPoint(cmdFlags)
	vaultAddress := flags.VaultAddressFlag(cmdFlags)
	vaultToken := flags.VaultTokenFlag(cmdFlags)
	err := cmdFlags.Parse(c.args)
	if err != nil {
		return 1
	}
	if len(*mount) == 0 {
		c.UI.Error("vault mount point is required")
		return 1
	}

	if len(inputs) == 0 {
		c.UI.Error("input paths are required")
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
	for _, v := range inputs {
		l.Trace("cli-push => InputFlag '%v'", v)
		// prepareTargets(v, *mount, *regex)
		targets, err := prepareTargets(v, *mount, *regex)
		if err != nil {
			c.UI.Warn(fmt.Sprintf("could not load files in '%v' due to err : %v", v, err))
			continue
		}
		for kk, vv := range targets {
			srcFile, _, err := files.SafeOpenPath(kk)
			if err != nil {
				c.UI.Warn(fmt.Sprintf("could not open file at '%s'.err: %v", kk, err))
				continue
			}
			defer srcFile.Close()
			payload, err := ioutil.ReadAll(srcFile)
			if err != nil {
				c.UI.Warn(fmt.Sprintf("could not load file in memory '%s'.err: %v", kk, err))
				continue
			}
			err = backend.Put(context.Background(), &vault.Entry{
				Key:   vv,
				Value: payload,
			}, "", "2")
			if err != nil {
				c.UI.Warn(fmt.Sprintf("could not store payload in vault at '%s'.err: %v", vv, err))
				continue
			}

		}

	}
	return 0
}

// Synopsis ...
func (c *Command) Synopsis() string {
	return "stores all files in a path recursively to vault."
}

// Help ...
func (c *Command) Help() string {
	helpText := `
Usage: kvctl push [options]

  recursively pushes all files in a directory
  to a KV engine in Vault.

Options:
  -log-level=INFO                       log level
								        Default: 'INFO'
  -input=fixtures/example               directory/file path for pushing to vault
                                        This can be specified multiple times.
  -regex=*.json                         regex for recursive search of files.
                                        Default: ''
  -mount=certificates                   Path on the local file system to
                                        mount vault as file system.
  -vault-token=root          			Agent's token to communicate with Vault cluster
  -vault-addr=http://127.0.0.1:8200     A single node in vault cluster.
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
func prepareTargets(source, mount, regex string) (map[string]string, error) {
	result := make(map[string]string)
	source, err := filepath.Abs(source)
	if err != nil {
		err = stacktrace.Propagate(err, "could not get absolute path for source path of '%v'", source)
		return nil, err
	}
	//
	// ()
	f, fi, err := files.OpenPath(source)
	if err != nil {
		err = stacktrace.Propagate(err, "could not open '%s'", source)
		return nil, err
	}
	defer f.Close()
	if !fi.IsDir() {
		// parent := strings.TrimPrefix(filepath.Dir(source), source)
		parent := filepath.Dir(source)

		vaultKey := strings.TrimSuffix(filepath.Base(source), filepath.Ext(source))
		result[source] = primitives.PathJoin(parent, vaultKey)
	} else {
		files, err := files.ReadDirFiles(source, regex)
		if err != nil {
			err = stacktrace.Propagate(err, "could search '%s' for '%s' pattern", source, regex)
			return nil, err
		}
		for _, v := range files {
			// parent := strings.TrimPrefix(filepath.Dir(v), source)
			parent := filepath.Dir(v)
			vaultKey := strings.TrimSuffix(filepath.Base(v), filepath.Ext(v))
			value := primitives.PathJoin(parent, vaultKey)
			key := primitives.PathJoin(source, v)
			result[key] = value
		}
	}
	return result, nil
}
