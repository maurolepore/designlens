# designlog

A design history tool for open source projects. Generates design history
through staged planning, task decomposition, and retrospective decision
records.

## What is designlog?

designlog helps maintain a living record of design decisions. Each project
"stage" produces a `plan.md` (the design), `tasks.md` (the breakdown), and
anonymized `decisions.md` (the reasoning). Combined with session transcript
summaries, this creates a comprehensive archaeological record of how and why
the code evolved the way it did.

Designed for open source workflows: specs live in the repo itself (`/specs`),
are committed to git, and tell the story of the project to future contributors.

## Installation

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/ropensci-review-tools/designlog/main/install.sh | bash
```

Then:
```bash
speclog init
```

### Windows

Run in PowerShell:
```powershell
irm https://raw.githubusercontent.com/ropensci-review-tools/designlog/main/install.ps1 | iex
```

Then:
```bash
speclog init
```

## Quick Start

```bash
# Initialize a project (run once)
designlog init

# Start a new stage (inside your agent, or from terminal)
designlog new-stage "auth-system"

# Check project state
designlog status

# Generate design decisions (auto-triggered or manual)
designlog retrospective

# Check version
designlog version
```

## Updating

```bash
designlog update
```

## Documentation

See `/docs/conventions.md` for the full specification of the workflow, formats, and agent instructions.

## Repository Structure

```
designlog/
  README.md
  designlog.json     (tool metadata and version)
  LICENSE            (MIT license)
  install.sh
  install.ps1
  bin/
    designlog
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
