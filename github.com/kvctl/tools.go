//go:build tools
// +build tools

package tools

// Manage tool dependencies via go.mod.
//
// https://github.com/golang/go/wiki/Modules#how-can-i-track-tool-dependencies-for-a-module
// https://github.com/golang/go/issues/25922
//
// nolint
import (
	_ "github.com/davidrjenni/reftools/cmd/fillstruct"
	_ "github.com/editorconfig-checker/editorconfig-checker/cmd/editorconfig-checker"
	_ "github.com/fatih/gomodifytags"
	_ "github.com/fatih/motion"
	_ "github.com/go-delve/delve/cmd/dlv"
	_ "github.com/golangci/golangci-lint/cmd/golangci-lint"
	_ "github.com/goreleaser/goreleaser"
	_ "github.com/josharian/impl"
	_ "github.com/jstemmer/gotags"
	_ "github.com/kisielk/errcheck"
	_ "github.com/klauspost/asmfmt/cmd/asmfmt"
	_ "github.com/koron/iferr"
	_ "github.com/kyoh86/richgo"
	_ "github.com/magefile/mage"
	_ "github.com/rogpeppe/godef"
	_ "github.com/stretchr/gorc"
	_ "golang.org/x/lint/golint"
	_ "golang.org/x/tools/cmd/goimports"
	_ "golang.org/x/tools/cmd/gorename"
	_ "golang.org/x/tools/cmd/guru"
	_ "golang.org/x/tools/gopls"
	_ "honnef.co/go/tools/cmd/keyify"
	_ "honnef.co/go/tools/cmd/staticcheck"
	_ "mvdan.cc/sh/v3/cmd/shfmt"
)

//go:generate go install -v "github.com/davidrjenni/reftools/cmd/fillstruct@latest"
//go:generate go install -v "github.com/fatih/gomodifytags@latest"
//go:generate go install -v "github.com/fatih/motion@latest"
//go:generate go install -v "github.com/go-delve/delve/cmd/dlv@latest"
//go:generate go install -v "github.com/josharian/impl@latest"
//go:generate go install -v "github.com/jstemmer/gotags@latest"
//go:generate go install -v "github.com/kisielk/errcheck@latest"
//go:generate go install -v "github.com/klauspost/asmfmt/cmd/asmfmt@latest"
//go:generate go install -v "github.com/koron/iferr@latest"
//go:generate go install -v "github.com/magefile/mage@latest"
//go:generate go install -v "github.com/rogpeppe/godef@latest"
//go:generate go install -v "github.com/stretchr/gorc@latest"
//go:generate go install -v "golang.org/x/lint/golint@latest"
//go:generate go install -v "golang.org/x/tools/cmd/goimports@latest"
//go:generate go install -v "golang.org/x/tools/cmd/gorename@latest"
//go:generate go install -v "golang.org/x/tools/cmd/guru@latest"
//go:generate go install -v "golang.org/x/tools/gopls@latest"
//go:generate go install -v "honnef.co/go/tools/cmd/keyify@latest"
//go:generate go install -v "honnef.co/go/tools/cmd/staticcheck@latest"
//go:generate go install -v "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
//go:generate go install -v "mvdan.cc/sh/v3/cmd/shfmt@latest"
//go:generate go install -v "github.com/kyoh86/richgo@latest"
//go:generate go install -v "github.com/editorconfig-checker/editorconfig-checker/cmd/editorconfig-checker@addFix"
//go:generate go install -v "github.com/goreleaser/goreleaser@latest"
