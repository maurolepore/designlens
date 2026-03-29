# designlens

A design history tool for open source projects. Generates design history
through staged planning, task decomposition, and retrospective decision
records.

## What is designlens?

designlens helps maintain a living record of design decisions. Each project
"stage" produces a `plan.md` (the design), `tasks.md` (the breakdown), and
anonymized `design-decisions.md` (the reasoning). Combined with session transcript
summaries, this creates a comprehensive archaeological record of how and why
the code evolved the way it did.

Designed for open source workflows: specs live in the repo itself (`/specs`),
are committed to git, and tell the story of the project to future contributors.

## Installation

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/ropensci-review-tools/designlens/main/install.sh | bash
```

### Windows

Run in PowerShell:
```powershell
irm https://raw.githubusercontent.com/ropensci-review-tools/designlens/main/install.ps1 | iex
```

This installs a lightweight CLI tool (~50KB, no dependencies) that you can use from your terminal.

### First Use

After installation, navigate to your git repository and run:

```bash
designlens init
```

This creates `/specs` folder and initializes designlens in your project. For existing projects, you'll be asked if you want to capture design history from your git log—this creates a starting point documenting architectural decisions from your project's evolution.

## Quick Start

In your project directory (git repo):

```bash
# Initialize designlens (run once per project)
designlens init

# Start a new design stage
designlens new-stage "feature-name"

# Check current project state
designlens status

# Generate design decisions after stage completion
designlens retrospective

# Check installed version
designlens version
```

## Updating

```bash
designlens update
```

## Uninstalling

```bash
designlens uninstall
```

Your projects' `/specs` folders and design history remain intact.

## Documentation

See `/docs/conventions.md` for the full specification of the workflow, formats, and agent instructions.

## Repository Structure

```
designlens/
  README.md
  designlens.json     (tool metadata and version)
  LICENSE            (MIT license)
  install.sh
  install.ps1
  bin/
    designlens
  lib/
    init.sh
    new-stage.sh
    retrospective.sh
    transcript.sh
    status.sh
    update.sh
  docs/
    conventions.md
```

## License

MIT. See [LICENSE](LICENSE) file for details.
