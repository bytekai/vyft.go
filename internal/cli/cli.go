package cli

import (
	"flag"
	"fmt"
	"io"
	"os"
)

func New(name, version string) *CLI {
	return &CLI{
		name:     name,
		version:  version,
		commands: make(map[string]Command),
	}
}

func (c *CLI) Register(cmd Command) {
	c.commands[cmd.Name()] = cmd
}

func (c *CLI) Execute(args []string) error {
	c.global = flag.NewFlagSet(c.name, flag.ContinueOnError)
	c.global.SetOutput(io.Discard)
	c.global.BoolVar(&c.showVersion, "version", false, "print version information")
	c.global.BoolVar(&c.showVersion, "v", false, "print version information (shorthand)")
	c.global.BoolVar(&c.help, "help", false, "print help information")
	c.global.BoolVar(&c.help, "h", false, "print help information (shorthand)")
	c.global.BoolVar(&c.verbose, "verbose", false, "enable verbose output")

	if err := c.global.Parse(args); err != nil {
		if err == flag.ErrHelp {
			c.printHelp()
			return nil
		}
		return err
	}

	if c.help {
		c.printHelp()
		return nil
	}

	if c.showVersion {
		c.printVersion()
		return nil
	}

	remaining := c.global.Args()
	if len(remaining) == 0 {
		c.printHelp()
		return nil
	}

	cmdName := remaining[0]
	cmd, exists := c.commands[cmdName]
	if !exists {
		return fmt.Errorf("unknown command: %s", cmdName)
	}

	cmdArgs := remaining[1:]
	fs := flag.NewFlagSet(cmdName, flag.ContinueOnError)
	fs.Usage = func() { printCommandHelp(c.name, cmd) }
	cmd.Flags(fs)

	if err := fs.Parse(cmdArgs); err != nil {
		if err == flag.ErrHelp {
			return nil
		}
		return err
	}

	ctx := &Context{
		Args:    fs.Args(),
		Verbose: c.verbose,
		Stdout:  os.Stdout,
		Stderr:  os.Stderr,
	}

	return cmd.Run(ctx)
}

func (c *CLI) printVersion() {
	fmt.Printf("%s version %s\n", c.name, c.version)
}
