package keygen

import (
	"flag"
)

// HexFlag ...
func HexFlag(f *flag.FlagSet) *bool {
	var result bool
	return f.Bool("hex", result,
		"encodes the result at hex.")
}

// Base64Flag ...
func Base64Flag(f *flag.FlagSet) *bool {
	var result bool
	return f.Bool("base64", result,
		"encodes the result at base64.")
}
