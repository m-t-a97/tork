# Makefile for building Tork
GITCOMMIT:=$(shell git describe --dirty --always)
BINARY:=./tmp/tork
SYSTEM:=
CHECKS:=check
BUILDOPTS:=-v
GOPATH?=$(HOME)/go
MAKEPWD:=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
CGO_ENABLED?=0

.PHONY: all
all: tork

tork: *.go go.* $(wildcard */**/*.go)
	CGO_ENABLED=$(CGO_ENABLED) $(SYSTEM) go build $(BUILDOPTS) -ldflags="-s -w -X github.com/runabol/tork.GitCommit=$(GITCOMMIT)" -o $(BINARY) cmd/main.go

.PHONY: clean
clean:
	go clean
	rm -f tork

.PHONY: generate-swagger
generate-swagger: docs/swagger.json

docs/swagger.json: *.go go.* $(wildcard */**/*.go)
	# Note: this command comes from https://github.com/swaggo/swag
	swag init  --parseDependency -g internal/coordinator/api/api.go --output docs
	rm docs/docs.go
	rm docs/swagger.yaml
