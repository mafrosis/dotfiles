---
agent: build
description: Implement an approved OpenSpec change and keep tasks in sync.
---
The user requested implementation of the tasks in the following openspec proposal.
<UserRequest>
  $ARGUMENTS
</UserRequest>

**Guardrails**
- Favor straightforward, minimal implementations first and add complexity only when it is requested or clearly required.
- Keep changes tightly scoped to the requested outcome.
- You MUST read `openspec/AGENTS.md` for further guidance before proceeding.

**Pre-flight**
1. Verify the proposal tasks list is numbered sequentially with no repetition of number or task.
2. Run the tests silently with `make test &>/dev/null` to ensure build is green.

**Steps**
1. Read `changes/<id>/proposal.md`, `design.md` (if present), and `tasks.md` to confirm scope and acceptance criteria.
2. Work through tasks sequentially, keeping edits minimal and focused on the requested change.
3. After implementing each task group, confirm completion and mark tasks complete in `tasks.md` with `- [x]`.
4. Before moving to the next task group, verify tests are successful and git commit the task group changes.

**Addendum**
1. Display a summary of work completed, including any task groups left incomplete.
2. Present the user with a Recommended Test Plan, showing steps & commands they can run to verify the functionality works as intended.
3. Write `changes/<id>/test_plan.md`. If the file already exists, update/merge with the existing content to leave a comprehensive test plan for future readers.

**Reference**
- Use `openspec show <id> --json --deltas-only` if you need additional context from the proposal while implementing.
