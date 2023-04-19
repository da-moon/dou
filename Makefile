DESTINATION=./bin/$(BINARY_NAME)

default: build

build:
	go build  -o $(DESTINATION)

.PHONY: install
install:
	go install