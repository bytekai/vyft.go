# vyft

A fast, extensible CLI tool written in Go.

## Features

- Clean, modular architecture
- Easy command extensibility
- Zero external dependencies
- Built with Go's standard library

## Installation

### Quick Install (Recommended)

**Note:** Install scripts require the repository to be published on GitHub with at least one release.

**Linux/macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/bytekai/vyft.go/main/install.sh | bash
```

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/bytekai/vyft.go/main/install.ps1 | iex
```

To install a specific version, set the `VYFT_VERSION` environment variable:

```bash
VYFT_VERSION=v0.1.0 curl -fsSL https://raw.githubusercontent.com/bytekai/vyft.go/main/install.sh | bash
```

### From Source

```bash
git clone https://github.com/bytekai/vyft.go.git
cd vyft.go
go build -o vyft
```

### Using Go Install

```bash
go install github.com/bytekai/vyft.go@latest
```

## Usage

```bash
vyft [flags] <command> [arguments]
```

### Global Flags

- `-h, --help` - Show help message
- `-v, --version` - Show version information
- `--verbose` - Enable verbose output

### Commands

Run `vyft --help` to see all available commands.

### Examples

```bash
vyft --version

vyft hello --name "World"

vyft --verbose hello
```

## Development

### Dev Container

This project includes a dev container configuration for VS Code and GitHub Codespaces:

1. Open in VS Code
2. Click "Reopen in Container" when prompted
3. Everything will be set up automatically

### Building

```bash
go build -o vyft
```

Or use the Makefile:

```bash
make build
```

### Project Structure

```
vyft-go/
├── main.go                  # Entry point
├── internal/
│   ├── cli/                # CLI framework
│   │   ├── types.go       # Core types
│   │   ├── cli.go         # Execution logic
│   │   └── help.go        # Help formatting
│   └── commands/           # Command implementations
│       └── hello.go       # Example command
```

### Adding a New Command

1. Create a new file in `internal/commands/`:

```go
package commands

import (
    "flag"
    "fmt"
    "github.com/bytekai/vyft.go/internal/cli"
)

type MyCommand struct {
    flagValue string
}

func NewMyCommand() *MyCommand {
    return &MyCommand{}
}

func (m *MyCommand) Name() string {
    return "mycommand"
}

func (m *MyCommand) Description() string {
    return "Description of my command"
}

func (m *MyCommand) Usage() string {
    return "vyft mycommand [flags]"
}

func (m *MyCommand) Flags(fs *flag.FlagSet) {
    fs.StringVar(&m.flagValue, "flag", "default", "flag description")
}

func (m *MyCommand) Run(ctx *cli.Context) error {
    fmt.Fprintf(ctx.Stdout, "Running mycommand\n")
    return nil
}
```

2. Register it in `main.go`:

```go
app.Register(commands.NewMyCommand())
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details.
