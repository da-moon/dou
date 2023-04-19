package rread

import (
	"flag"
)

// KeyPrefixFlag key prefix for searching recursively
func KeyPrefixFlag(f *flag.FlagSet) *string {
	var result string
	return f.String("key-prefix", result,
		"vault kv key-prefix for recursive listing.")
}
