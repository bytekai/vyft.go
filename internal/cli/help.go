package cli

import (
	"fmt"
	"sort"
)

func (c *CLI) printHelp() {
	fmt.Printf("%s - A CLI tool\n\n", c.name)
	fmt.Println("Usage:")
	fmt.Printf("  %s [flags] <command> [arguments]\n\n", c.name)

	fmt.Println("Global Flags:")
	fmt.Println("  -h, --help       Show this help message")
	fmt.Println("  -v, --version    Show version information")
	fmt.Println("  --verbose        Enable verbose output")

	if len(c.commands) > 0 {
		fmt.Println("\nCommands:")
		names := make([]string, 0, len(c.commands))
		for name := range c.commands {
			names = append(names, name)
		}
		sort.Strings(names)

		for _, name := range names {
			fmt.Printf("  %-15s %s\n", name, c.commands[name].Description())
		}
	}

	fmt.Println("\nExamples:")
	fmt.Printf("  %s --version\n", c.name)
	fmt.Printf("  %s --help\n", c.name)
	if len(c.commands) > 0 {
		names := make([]string, 0, len(c.commands))
		for name := range c.commands {
			names = append(names, name)
		}
		sort.Strings(names)
		if len(names) > 0 {
			fmt.Printf("  %s %s\n", c.name, names[0])
		}
	}
}

func printCommandHelp(cliName string, cmd Command) {
	fmt.Printf("%s %s - %s\n\n", cliName, cmd.Name(), cmd.Description())
	fmt.Println("Usage:")
	fmt.Printf("  %s\n\n", cmd.Usage())
	fmt.Println("Flags:")
}
