---
agent: build
description: Amend an already completed OpenSpec change proposal.
---
The user has requested an amendment to the following change proposal. Use the openspec instructions to complete their request.
<UserRequest>
  $ARGUMENTS
</UserRequest>

**Guardrails**
- Favor straightforward, minimal implementations first and add complexity only when it is requested or clearly required.
- Keep changes tightly scoped to the requested outcome.
- You MUST read `openspec/AGENTS.md` for further guidance before proceeding.
- Identify any vague or ambiguous details and ask the necessary follow-up questions before editing files.

**Steps**
Track these steps as TODOs and complete them one by one.
1. Read `changes/<id>/proposal.md`, `design.md` (if present), and `tasks.md` to confirm scope and acceptance criteria.
2. Consider the user's amendment request, and propose a solution.
3. Capture architectural reasoning in `design.md` when the solution spans multiple systems, introduces new patterns, or demands trade-off discussion before committing to specs.
4. Create or amend spec deltas in `changes/<id>/specs/<capability>/spec.md` (one folder per capability) using `## ADDED|MODIFIED|REMOVED Requirements` with at least one `#### Scenario:` per requirement and cross-reference related capabilities when relevant.
5. Update `tasks.md` with a new section for this amendment. Create as an ordered list of small, verifiable work items that deliver user-visible progress, include validation (tests, tooling), and highlight dependencies or parallelizable work. Prefix task groups with 'A' indicating amendment; eg. A1.1, A1.2, A2.1..
6. Validate with `openspec validate <id> --strict` and resolve every issue before sharing the proposal.
7. Create a git commit containing just the amended proposal files.

**Reference**
- Use `openspec show <id> --json --deltas-only` if you need additional context from the proposal while implementing.
