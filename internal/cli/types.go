package cli

import (
	"flag"
	"io"
)

type Context struct {
	Args    []string
	Verbose bool
	Stdout  io.Writer
	Stderr  io.Writer
}

type Command interface {
	Name() string
	Description() string
	Usage() string
	Run(ctx *Context) error
	Flags(fs *flag.FlagSet)
}

type CLI struct {
	name        string
	version     string
	commands    map[string]Command
	global      *flag.FlagSet
	verbose     bool
	help        bool
	showVersion bool
}
