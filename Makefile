.PHONY: build clean install run help

BINARY_NAME=vyft
GO=go
BUILD_DIR=.

build:
	$(GO) build -o $(BUILD_DIR)/$(BINARY_NAME) .

clean:
	rm -f $(BUILD_DIR)/$(BINARY_NAME)
	$(GO) clean

install:
	$(GO) install .

run:
	$(GO) run .

lint:
	$(GO) vet ./...
	$(GO) fmt ./...

help:
	@echo "Available targets:"
	@echo "  build   - Build the binary"
	@echo "  clean   - Remove built binary"
	@echo "  install - Install to GOPATH/bin"
	@echo "  run     - Run without building"
	@echo "  lint    - Run linters and formatters"
	@echo "  help    - Show this help message"

