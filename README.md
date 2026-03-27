# speclog

A spec tracking tool for open source projects. Generates design history through staged planning, task decomposition, and retrospective decision records.

## What is speclog?

speclog helps teams and solo developers maintain a living record of design decisions. Each project "stage" produces a `plan.md` (the design), `tasks.md` (the breakdown), and automatically-generated `decisions.md` (the why). Combined with session transcripts, this creates a comprehensive archaeological record of how and why the code evolved the way it did.

Designed for open source workflows: specs live in the repo itself (`/specs`), are committed to git, and tell the story of the project to future contributors.

## Installation

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/[repo]/install.sh | bash
```

Then:
```bash
speclog init
```

### Windows

Run in PowerShell:
```powershell
irm https://raw.githubusercontent.com/[repo]/install.ps1 | iex
```

Then:
```bash
speclog init
```

## Quick Start

```bash
# Initialize a project (run once)
speclog init

# Start a new stage (inside your agent, or from terminal)
speclog new-stage "auth-system"

# Check project state
speclog status

# Generate design decisions (auto-triggered or manual)
speclog retrospective
```

## Updating

```bash
speclog update
```

## Documentation

See `/docs/conventions.md` for the full specification of the workflow, formats, and agent instructions.

## Repository Structure

```
speclog/
  README.md
  install.sh
  install.ps1
  bin/
    speclog
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

TBD
