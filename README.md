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

This installs a lightweight bash-based tool (~50KB) to `/usr/local/lib/designlog` with a symlink at `/usr/local/bin/designlog`. No dependencies beyond bash, curl, and git.

### Setup

After installation, navigate to the git repository where you want to use designlog and run:

```bash
designlog init
```

This initializes designlog in your project (creates `/specs`, lockfile, and agent instructions).

### Windows Setup

Run the installer in PowerShell:
```powershell
irm https://raw.githubusercontent.com/ropensci-review-tools/designlog/main/install.ps1 | iex
```

Then navigate to your git repository and run:
```bash
designlog init
```

## Quick Start

In your project directory (git repo):

```bash
# Initialize designlog (run once per project)
designlog init

# Start a new design stage
designlog new-stage "feature-name"

# Check current project state
designlog status

# Generate design decisions after stage completion
designlog retrospective

# Check installed version
designlog version
```

## Updating

```bash
designlog update
```

## Uninstalling

To remove designlog:

```bash
designlog uninstall
```

Or manually:
```bash
rm -rf /usr/local/lib/designlog
rm /usr/local/bin/designlog
```

This leaves your projects' `/specs` folders and design history intact—only the tool itself is removed.

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
