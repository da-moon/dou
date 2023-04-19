# Repository Management

- [Repository Management](#repository-management)
  - [Overview](#overview)
  - [Github](#github)
    - [github-label-sync](#github-label-sync)
    - [go-releaser](#go-releaser)

## Overview

The purpose of this documentation is to list the set of tools
used for managing and automating the repository management.

## Github

### [github-label-sync][github-label-sync-url]

This tool is used for the repository labels management

- install

```bash
sudo npm install github-label-sync -g
```

- Update labels

```bash
export GITHUB_TOKEN="<your-github-token>" ;
github-label-sync --access-token "${GITHUB_TOKEN}" --labels ".github-labels.json" "DigitalOnUs/vault-kvctl"
```

### [go-releaser][go-releaser-url]

- build generate a release while skipping Github upload

```bash
goreleaser release --rm-dist --snapshot --rm-dist
```

[github-label-sync-url]: https://github.com/Financial-Times/github-label-sync
[go-releaser-url]: https://goreleaser.com
