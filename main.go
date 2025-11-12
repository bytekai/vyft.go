package main

import (
	"fmt"
	"os"

	"github.com/vyftlabs/vyft/internal/cli"
	"github.com/vyftlabs/vyft/internal/commands"
)

const version = "0.1.0"

func main() {
	app := cli.New("vyft", version)

	app.Register(commands.NewHello())

	if err := app.Execute(os.Args[1:]); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
