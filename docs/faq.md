# FAQ & Tools

Frequently asked questions, command reference, and Git workflows.

## FAQ

**Q: Can I use designlens with agents other than Claude Code and OpenCode?**
A: Yes, with a manual step. During `designlens init`, select `other` at the agent prompt. Proforma command files will be created in `.opencode/command/` as a starting point. Copy them to your agent's commands directory (e.g. `.github/agents/`, `.cursor/rules/`) and modify them to match your agent's slash command or prompt format. The underlying workflow is agent-agnostic; only the slash command files need adapting. To request native support for additional agents, open an issue at https://github.com/ropensci-review-tools/designlens/issues.

**Q: Should we commit the .designmeta.json lockfile?**
A: Yes, it's useful for future contributors to know what tool was used and where to find docs.

**Q: What if the human and AI disagree on a design?**
A: Document both perspectives in plan.md under a "Considered Alternatives" section. The human makes the final call, but recording the discussion is valuable history.

**Q: Can a stage skip tasks.md and go straight to code?**
A: Not recommended. tasks.md is the bridge between intention (plan.md) and action. If the plan is solid, tasks should be quick to write and invaluable for tracking progress.

**Q: What if a task is discovered mid-implementation?**
A: Add it to tasks.md and update the task count in the checklist. This is part of normal development.

**Q: How do we handle mistakes or design changes mid-stage?**
A: Update plan.md and tasks.md to reflect the change. Git will track the changes. Mention the decision in design-decisions.md at retrospective time.

**Q: Can multiple people work on one stage?**
A: Yes. Use git branches and merging as normal. Transcript speaker labels use `git config user.name` for each participant; message content should be semi-anonymized (no personal expressions or identifying information). Git metadata (branch author, commit history) provides additional attribution context if needed.

**Q: How long should a stage be?**
A: As long as it needs. Some stages might be a few hours; others might be weeks. If a stage is getting very long, consider breaking it into multiple stages.

## Command Reference

### Shell commands

```bash
designlens init                          # Initialize project (once)
designlens new-stage "<desc>" "<slug>"   # Create next stage directory and plan.md
designlens status                        # Show current state and next action
designlens config show                   # View current configuration
designlens config set <key> <value>      # Set a configuration value
designlens update                        # Update to latest version
designlens uninstall                     # Uninstall from system
```

### Agent slash commands (installed by `init`)

```
/designlens.new-stage       # 1. Gather requirements and create a new stage
/designlens.make-tasks      # 2. Generate tasks.md from the current plan.md
/designlens.implement       # 3. Implement all tasks in the current tasks.md
/designlens.retrospective   # 4. Generate transcript and design decisions
/designlens.help            # Show help
```

## IDE Integration

Workflow commands run natively inside your agent via slash commands (installed by `designlens init`). Shell commands like `designlens status` can be run directly in the terminal or via your agent's shell tool.

## Git Workflow

```bash
# Start a new stage (agent handles the planning)
# /designlens.new-stage → calls designlens new-stage internally
git checkout -b specs/feature-name

# Work on the stage
# /designlens.implement → checks off tasks as they complete
git add .
git commit -m "WIP: Feature implementation"

# Complete the stage
# /designlens.retrospective → generates design-decisions.md
git add specs/feature-name/
git commit -m "feature-name: Design decisions"

# Merge
git checkout main
git merge specs/feature-name
```

---

For more information, see [conventions.md](conventions.md) for the overview and folder structure, [workflow.md](workflow.md) for the complete phase breakdown, and [file-formats.md](file-formats.md) for templates.
