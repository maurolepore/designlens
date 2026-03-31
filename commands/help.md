Display a summary of how designlens works and what commands are available in this session.

Show the user the following:

---

## designlens — Design history and architectural decision tracking

### Shell commands (`designlens <command>`)

| Command | Description |
|---|---|
| `designlens init` | Initialize a project (run once) |
| `designlens new-stage "<desc>" "<slug>"` | Create the next stage directory and plan.md |
| `designlens status` | Show current project state |
| `designlens config show` | View current configuration |
| `designlens config set <key> <value>` | Set a configuration value |
| `designlens update` | Update designlens to latest version |
| `designlens uninstall` | Uninstall designlens from system |

### Workflow slash commands (installed by `init`)

| Command | Description |
|---|---|
| `/new-stage` | Gather requirements and create a new stage |
| `/make-tasks` | Generate tasks.md from the current plan.md |
| `/implement` | Implement all tasks in the current tasks.md |
| `/retrospective` | Generate transcript and design decisions |
| `/help` | Show this help |

### Typical workflow

1. `designlens init` — once per project
2. `/new-stage` — design and plan a stage
3. `/make-tasks` — break the plan into tasks
4. `/implement` — execute the tasks
5. `/retrospective` — capture decisions and update the design history
6. Repeat from step 2

### Configuration (`.designlens.json`)

- `auto_commit` — if `true`, automatically commit specs after implementation and retrospective
- `agent` — which agent is in use (`claude` or `opencode`)
- `commands_path` — where the slash command files are installed

For full documentation run `designlens help` in the shell, or read `docs/conventions.md` in the designlens repo.
