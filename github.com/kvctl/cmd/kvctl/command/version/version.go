package version

import (
	"strings"

	buildver "github.com/DigitalOnUs/kvctl/internal/version"
	cli "github.com/mitchellh/cli"
)

func New(ui cli.Ui) *Command {
	c := &Command{
		UI: ui,
	}
	return c
}

type Command struct {
	UI       cli.Ui
	help     string
	synopsis string
}

// Run ...
func (c *Command) Run(_ []string) int {
	build := buildver.New()
	c.UI.Output(build.ToString())
	return 0
}

// Help ...
func (c *Command) Help() string {
	return strings.TrimSpace(c.help)
}

// Synopsis ...
func (c *Command) Synopsis() string {
	return "returns build information including version."
}

const help = `
Usage: kvctl version

returns current release build version.
`
