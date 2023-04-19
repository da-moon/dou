# [ TODO ] mcr.microsoft.com/vscode/devcontainers/alpine
# https://github.com/microsoft/vscode-dev-containers/tree/master/containers/alpine/.devcontainer
FROM golang:alpine
USER root
ENV GO111MODULE=on
ARG GOLANGCI_LINT_VERSION=v1.35.2
ARG GOPLS_VERSION=v0.6.4
ARG DELVE_VERSION=v1.5.0
ARG GOMODIFYTAGS_VERSION=v1.13.0
ARG GOPLAY_VERSION=v1.0.0
ARG GOTESTS_VERSION=v1.5.3
ARG STATICCHECK_VERSION=2020.2.1

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" | tee /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" |  tee -a /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" |  tee -a /etc/apk/repositories && \
  apk upgrade --no-cache && \
  apk add --no-cache --progress git build-base findutils make bat exa \
  coreutils wget curl aria2 bash ncurses upx binutils jq sudo ripgrep g++ \
  vault fuse-dev libcap neofetch && \
  setcap cap_ipc_lock= /usr/sbin/vault && \
  vault --version && \
  sed -i '/root/s/ash/bash/g' /etc/passwd
RUN wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /bin -d ${GOLANGCI_LINT_VERSION}
# Base Go tools needed for VS code Go extension
RUN go install golang.org/x/tools/gopls@${GOPLS_VERSION}
RUN go install github.com/ramya-rao-a/go-outline@latest 
RUN go install golang.org/x/tools/cmd/guru@latest 
RUN go install golang.org/x/tools/cmd/gorename@latest 
RUN go install github.com/go-delve/delve/cmd/dlv@${DELVE_VERSION}
# Extra tools integrating with VS code
RUN go install github.com/fatih/gomodifytags@${GOMODIFYTAGS_VERSION}
RUN go install github.com/haya14busa/goplay/cmd/goplay@${GOPLAY_VERSION} 
RUN go install github.com/cweill/gotests/...@${GOTESTS_VERSION} 
RUN go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
# Extra Tools
RUN GO111MODULE=on  go install mvdan.cc/gofumpt@latest
RUN GO111MODULE=on  go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
RUN GO111MODULE=on  go install github.com/cuonglm/gocmt@latest
# RUN GO111MODULE=off go install github.com/palantir/go-compiles
# RUN GO111MODULE=off go install github.com/mohae/nocomment/cmd/nocomment
# RUN GO111MODULE=off go install github.com/eandre/discover/...
# RUN GO111MODULE=off go install honnef.co/go/tools/cmd/staticcheck && \
#   cd $GOPATH/src/honnef.co/go/tools/cmd/staticcheck && \
#   git checkout ${STATICCHECK_VERSION} 
RUN rm -rf $GOPATH/pkg/* $GOPATH/src/* /root/.cache/go-build
RUN go env -w GOPRIVATE=github.com/DigitalOnUs

WORKDIR /workspace