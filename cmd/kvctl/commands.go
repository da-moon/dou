package main

import (
	"os"

	compare "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/compare"
	cp "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/cp"
	keygen "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/keygen"
	push "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/push"
	rlist "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/rlist"
	rread "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/rread"
	version "github.com/DigitalOnUs/kvctl/cmd/kvctl/command/version"
	cli "github.com/mitchellh/cli"
)

// Commands is the mapping of all the available Serf commands.
var Commands map[string]cli.CommandFactory

func init() {
	ui := &cli.BasicUi{
		Reader:      os.Stdin,
		Writer:      os.Stdout,
		ErrorWriter: os.Stderr,
	}
	Commands = map[string]cli.CommandFactory{

		"push": func() (cli.Command, error) {
			return &push.Command{
				UI: ui,
			}, nil
		},
		"rlist": func() (cli.Command, error) {
			return &rlist.Command{
				UI: ui,
			}, nil
		},
		"rread": func() (cli.Command, error) {
			return &rread.Command{
				UI: ui,
			}, nil
		},
		"cp": func() (cli.Command, error) {
			return &cp.Command{
				UI: ui,
			}, nil
		},
		"compare": func() (cli.Command, error) {
			return &compare.Command{
				UI: ui,
			}, nil
		},
		"keygen": func() (cli.Command, error) {
			return &keygen.Command{
				UI: ui,
			}, nil
		},
		"version": func() (cli.Command, error) {
			return &version.Command{
				UI: ui,
			}, nil
			//return version.New(ui), nil
		},
	}
}
