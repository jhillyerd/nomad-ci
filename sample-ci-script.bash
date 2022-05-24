#!/bin/bash

echo "Hello from $(pwd)"
ls

go clean $(go list ./... | grep -v /vendor/)
go get ./...
go build
go test -race ./...
