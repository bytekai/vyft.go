package commands

import (
	"flag"
	"fmt"

	"github.com/bytekai/vyft.go/internal/cli"
)

type Hello struct {
	name string
}

func NewHello() *Hello {
	return &Hello{}
}

func (h *Hello) Name() string {
	return "hello"
}

func (h *Hello) Description() string {
	return "Print a hello message"
}

func (h *Hello) Usage() string {
	return "vyft hello [--name NAME]"
}

func (h *Hello) Flags(fs *flag.FlagSet) {
	fs.StringVar(&h.name, "name", "World", "name to greet")
}

func (h *Hello) Run(ctx *cli.Context) error {
	if ctx.Verbose {
		fmt.Fprintf(ctx.Stderr, "Running hello command with args: %v\n", ctx.Args)
	}

	fmt.Fprintf(ctx.Stdout, "Hello, %s!\n", h.name)
	return nil
}
