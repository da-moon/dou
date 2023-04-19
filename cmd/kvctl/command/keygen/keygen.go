package keygen

import (
	"crypto/rand"
	"encoding/hex"
	"flag"
	"fmt"
	"strings"

	"github.com/da-moon/go-codec"

	"github.com/mitchellh/cli"
)

// Command is a Command implementation that generates an encryption
// key.
//  [ TODO ] flags for base64-hex
type Command struct {
	UI   cli.Ui
	args []string
}

var _ cli.Command = &Command{}

// Run ...
func (c *Command) Run(args []string) int {
	const length = 32
	const entrypoint = "keygen"
	c.args = args
	c.UI = &cli.PrefixedUi{
		OutputPrefix: "",
		InfoPrefix:   "",
		ErrorPrefix:  "",
		Ui:           c.UI,
	}
	cmdFlags := flag.NewFlagSet(entrypoint, flag.ContinueOnError)
	cmdFlags.Usage = func() { c.UI.Info(c.Help()) }
	hexEncode := HexFlag(cmdFlags)
	baseEncode := Base64Flag(cmdFlags)
	err := cmdFlags.Parse(c.args)
	if err != nil {
		return 1
	}
	key := make([]byte, length)
	n, err := rand.Reader.Read(key)
	if err != nil {
		c.UI.Error(fmt.Sprintf("could not read random data: %s", err))
		return 1
	}
	if n != length {
		c.UI.Error("could not read enough entropy. Generate more entropy!")
		return 1
	}
	hexResult := hex.EncodeToString(key)
	baseResult := hex.EncodeToString(key)
	if *hexEncode && *baseEncode {
		type response struct {
			Hex    string `json:"hex"`
			Base64 string `json:"base64"`
		}
		result, err := codec.EncodeJSONWithIndentation(response{
			Hex:    hexResult,
			Base64: baseResult,
		})
		if err != nil {
			c.UI.Error(fmt.Sprintf("err:%v", err))
			return 1
		}
		c.UI.Output(string(result))
		return 0
	} else if *hexEncode {
		c.UI.Output(hexResult)
		return 0
	} else if *baseEncode {
		c.UI.Output(baseResult)
		return 0
	}
	c.UI.Error("you must choose encoding scheme!")
	return 1
}

// Synopsis ...
func (c *Command) Synopsis() string {
	return "Generates a new encryption key"
}

// Help ...
func (c *Command) Help() string {
	helpText := `
Usage: kvctl keygen

  Generates a new 32 bytes long random encryption key that can be used to for encrypting data.

  in case both base64 and hex output is requested, the result will be returned as a json
  reply, containing both values.

  Options:

  -base64                         encode the key as base 64
  -hex                         	  encode the key as hex

`
	return strings.TrimSpace(helpText)
}
