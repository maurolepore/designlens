# FAQ & Tools

Frequently asked questions, command reference, and Git workflows.

## FAQ

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

```bash
designlens init                    # Initialize project (once)
designlens new-stage <name>        # Create new stage
designlens status                  # Show current state and next action
designlens retrospective           # Generate design-decisions.md
designlens transcript <file>       # Normalize a transcript
designlens update                  # Update to latest version
```

## IDE Integration

Most IDEs and coding agents (Claude Code, Cursor, etc.) can execute shell commands. Use that to call designlens commands during a session.

## Git Workflow

```bash
# Start a new stage
designlens new-stage "feature-name"
git checkout -b specs/feature-name

# Work on the stage
[edit plan.md, write code, check off tasks]
git add .
git commit -m "WIP: Feature implementation"

# Complete the stage
designlens retrospective
git add specs/feature-name/design-decisions.md
git commit -m "feature-name: Design decisions"

# Merge
git checkout main
git merge specs/feature-name
```

---

For more information, see [conventions.md](conventions.md) for the overview and folder structure, [workflow.md](workflow.md) for the complete phase breakdown, and [file-formats.md](file-formats.md) for templates.
