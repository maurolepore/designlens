---
description: Generate tasks.md from the current stage's plan.md
---

Find the highest-numbered stage directory under `specs/` (e.g. `specs/003-foo/`). Verify that `plan.md` exists in it. If it does not, stop and tell the user to run `/designlens.new-stage` first.

If `tasks.md` already exists in that directory, ask the user before overwriting.

Read `plan.md` and generate `tasks.md` in the same directory. Break the plan into concrete, actionable tasks with checkboxes. Each task must:

- Have a unique ID of the form `T<stage>-N`, where `<stage>` is the zero-padded stage number and `N` is the sequential task number within this stage starting at 1 (e.g. `T003-1`, `T003-2`).
- Use that ID as the task heading and in the checkbox line:
  ```
  ## T003-1: <short title>
  - [ ] T003-1: <full description>
  ```
- Be specific enough to be implementable without further clarification.

Once `tasks.md` is written, show it to the user and ask them to review it. When they are satisfied, tell them to run `/designlens.implement`.
