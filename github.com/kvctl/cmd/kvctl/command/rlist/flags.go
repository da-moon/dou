package rlist

import (
	"flag"
)

// KeyPrefixFlag key prefix for searching recursively
func KeyPrefixFlag(f *flag.FlagSet) *string {
	var result string
	return f.String("key-prefix", result,
		"vault kv key-prefix for recursive listing.")
}

// HexFlag ...
func FlatFlag(f *flag.FlagSet) *bool {
	var result bool
	return f.Bool("flat", result,
		"returns a flattened list of entry keys.")
}
