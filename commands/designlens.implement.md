---
description: "3. Implement all tasks in the current stage's tasks.md"
---

Find the highest-numbered stage directory under `specs/`. Verify that both `plan.md` and `tasks.md` exist in it. If `plan.md` does not exist, stop and tell the user to run `/designlens.new-stage` first. If `plan.md` exists but `tasks.md` does not, stop and tell the user to run `/designlens.make-tasks` first.

Read `.designlens.json` to get the `auto_commit` setting.

Implement all tasks listed in `tasks.md`, in order, one by one.

Rules:
1. Work through tasks sequentially by ID — do not skip or reorder.
2. Mark each checkbox as complete (`- [x]`) immediately upon finishing that task.
3. Do not stop or pause between tasks for any reason other than to request clarification from the user (see rule 4).
4. If any uncertainty arises — including potential conflicts between tasks, ambiguous requirements, or unexpected obstacles — pause and ask the user for clarification before proceeding. Resume immediately once resolved.
5. Implementation is not complete until every checkbox in `tasks.md` is checked. Do not report completion while any checkbox remains unchecked.

On completion:

```bash
git add <stage_dir>/plan.md <stage_dir>/tasks.md
```

Before mentioning retrospective at all, check whether there is enough history for one. Run:
```bash
designlens lib commits-since-stage
```
Parse `total_commits=` and `threshold=` from the output. If `total_commits` < `threshold`, this is a brand-new repository — skip retrospective entirely: do not ask about it or tell the user to run it. If `auto_commit` is `true`, commit now with `git commit -m "<NNN>: Add specs"`. Then stop; tell the user the stage is complete and there wasn't enough commit history yet for a retrospective.

Otherwise, based on `auto_commit`:

- If `true`: ask the user "Generate retrospective before committing stage specs? (y/n)".
  - If y: run `/designlens.retrospective`, then commit everything: `git add <stage_dir>/` && `git commit -m "<NNN>: Add specs and design decisions"`.
  - If n: ask "Run retrospective anyway without committing? (y/n)". If y: run `/designlens.retrospective` and stop. If n: stop.
- If `false`: tell the user to run `/designlens.retrospective`.
