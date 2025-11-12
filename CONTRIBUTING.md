# Contributing to vyft

Thank you for your interest in contributing to vyft!

## Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/vyft.git
   cd vyft
   ```
3. Build the project:
   ```bash
   go build -o vyft
   ```

## Making Changes

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes

3. Format your code:
   ```bash
   go fmt ./...
   ```

4. Run linters:
   ```bash
   go vet ./...
   ```

5. Build and test:
   ```bash
   go build -o vyft
   ./vyft --help
   ```

## Commit Guidelines

- Use clear, descriptive commit messages
- Keep commits focused on a single change
- Reference issues in commit messages when applicable

## Pull Request Process

1. Update the README.md with details of changes if applicable
2. Ensure the code builds and runs correctly
3. Create a Pull Request with a clear description of the changes

## Code Style

- Follow standard Go conventions
- Keep functions small and focused
- Maintain the clean architecture pattern
- No external dependencies unless absolutely necessary
- No comments (as per project style)

## Adding New Commands

See the README.md for instructions on adding new commands to the CLI.

## Questions?

Feel free to open an issue for any questions or discussions.

