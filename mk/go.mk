.PHONY: format run build test dbshell

# goimports provides imports grouping which is kinda
# the appropriate way to do things according to me
# so ditch go fmt and user goimports instead
format:
	@goimports -format-only ./...

run:
	@go run .

build:
	@go build ./... 

test:
	@go test ./...

dbshell:
	@echo 'connecting to the database ...'
