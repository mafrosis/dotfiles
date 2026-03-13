---
agent: build
description: Resolve review findings on an OpenSpec change implementation.
---
The user requested implementation of the tasks in the following openspec proposal.
<UserRequest>
  $ARGUMENTS
</UserRequest>

**Guardrails**
- Favor straightforward, minimal implementations first and add complexity only when it is requested or clearly required.
- Keep changes tightly scoped to the requested outcome.
- You MUST read `openspec/AGENTS.md` for further guidance before proceeding.

**Steps**
Track these steps as TODOs and complete them one by one.
1. Read `changes/<id>/proposal.md`, `design.md` (if present), and `tasks.md` to understand change scope, design & implementation.
2. Read `changes/<id>/review.md` to understand code review findings. If `review.md` is missing YOU MUST ABORT.
3. Work sequentially through code review todo in `tasks.md`, keeping edits minimal and focused on fixing each issue.
4. Before moving to the next review finding, verify tests are successful and git commit the resolved code.

**Reference**
- Use `openspec show <id> --json --deltas-only` if you need additional context from the proposal while implementing.
