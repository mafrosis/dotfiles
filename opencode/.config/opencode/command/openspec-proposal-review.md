---
agent: build
variant: high
description: Provide critical review of an OpenSpec change before implementation.
---
The user has requested a review of the following change proposal.
<UserRequest>
  $ARGUMENTS
</UserRequest>

**Guardrails**
- Favor straightforward, minimal implementations first and add complexity only when it is requested or clearly required.
- Keep changes tightly scoped to the requested outcome.
- You MUST read `openspec/AGENTS.md` for further guidance before proceeding.
- Identify any vague or ambiguous details and ask the necessary follow-up questions before editing files.
- Whilst developing a design, review the codebase and ALWAYS reuse existing patterns.
- At any time you can throw out the proposal and rewrite from scratch based on new information provided by the user.

**Pre-flight**
1. Ensure the requested change proposal already exists (via the prompt or `openspec list`).
2. If the file `tasks.md` is present in the change directory, ensure that no tasks are marked complete. If tasks are marked complete, ABORT and warn the user that implementation has already started and the proposal should not be modified.

**Steps**
1. Read `changes/<id>/proposal.md`, `design.md` (if present), and `tasks.md` to confirm scope and acceptance criteria. Note any gaps that require clarification.
2. Assess the problem statement, and determine if the proposal as written will solve this objective. Consider any missing edge cases or false assumptions made.
3. Assess the tasks list completeness to meet the objective.
4. Assess the Openspec specs coverage of the problem solution.
5. Ask the user questions as necessary to clarify your understanding.
6. Rewrite from scratch the proposal files based on new findings.
7. Validate with `openspec validate <id> --strict` and resolve every issue before sharing the proposal.
8. Create a new git commit containing the updated proposal files.

**Reference**
- Use `openspec show <id> --json --deltas-only` or `openspec show <spec> --type spec` to inspect details when validation fails.
- Search existing requirements with `rg -n "Requirement:|Scenario:" openspec/specs` before writing new ones.
- Explore the codebase with `rg <keyword>`, `ls`, or direct file reads so proposals align with current implementation realities.
