package push

import (
	"flag"
)

func EntryPointFlag(f *flag.FlagSet) *string {
	var result string
	return f.String("entrypoint", result,
		"sets entrypoint for recursive search of files.")
}

// RegexFlag ...
func RegexFlag(f *flag.FlagSet) *string {
	var result string
	return f.String("regex", result,
		"regex used for recursive file search")
}
