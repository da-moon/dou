package strutils

import (
	"encoding/json"
	"io"
	"strings"
)

// SanitizePath removes any leading or trailing things from a "path".
func SanitizePath(s string) string {
	return EnsureTrailingSlash(EnsureNoLeadingSlash(strings.TrimSpace(s)))
}

// EnsureNoLeadingSlash ensures the given string has a trailing slash.
func EnsureNoLeadingSlash(s string) string {
	s = strings.TrimSpace(s)
	if s == "" {
		return ""
	}

	for len(s) > 0 && s[0] == '/' {
		s = s[1:]
	}
	return s
}

// EnsureTrailingSlash ensures the given string has a trailing slash.
func EnsureTrailingSlash(s string) string {
	s = strings.TrimSpace(s)
	if s == "" {
		return ""
	}

	for len(s) > 0 && s[len(s)-1] != '/' {
		s = s + "/"
	}
	return s
}

// EnsureNoTrailingSlash ensures the given string has a trailing slash.
func EnsureNoTrailingSlash(s string) string {
	s = strings.TrimSpace(s)
	if s == "" {
		return ""
	}

	for len(s) > 0 && s[len(s)-1] == '/' {
		s = s[:len(s)-1]
	}
	return s
}

// ParseStringSlice parses a `sep`-separated list of strings into a
// []string with surrounding whitespace removed.
// The output will always be a valid slice but may be of length zero.
func ParseStringSlice(input, sep string) []string {
	input = strings.TrimSpace(input)
	if input == "" {
		return []string{}
	}

	splitStr := strings.Split(input, sep)
	ret := make([]string, len(splitStr))
	for i, val := range splitStr {
		ret[i] = strings.TrimSpace(val)
	}
	return ret
}

func PrettyEncode(data interface{}, out io.Writer) error {
	enc := json.NewEncoder(out)
	enc.SetIndent("", "    ")
	if err := enc.Encode(data); err != nil {
		return err
	}
	return nil
}
