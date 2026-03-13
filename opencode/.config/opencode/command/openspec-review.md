---
agent: review
description: Review the implementation of an OpenSpec change for quality and adherance to the spec.
---
The user requested review of the following openspec proposal implementation.
<UserRequest>
  $ARGUMENTS
</UserRequest>

**Guardrails**
- Favor simple, yet high quality code. Ensure that all specification constraints are met.
- Keep changes tightly scoped to the requested outcome.
- You MUST read `openspec/AGENTS.md` for further guidance before proceeding.

**Focus Areas**
* Spec Compliance & Project Standards
* Code Quality & Best Practices
* Removing Logic Duplication
* Bugs & Edge Cases
* Security: Verify sanitized untrusted inputs (especially SQL injection, XSS, command injection)
* Testing Coverage
* Documentation

**Steps**
1. Read `changes/<id>/proposal.md`, `design.md` (if present), and `tasks.md` to confirm scope and acceptance criteria.
2. Work through tasks sequentially, reviewing the implemented code to verify adherence to the spec and design.
3. Provide a comprehensive review of the FOCUS AREAS.
4. Make a determination of whether the code implementation meets the proposal.
5. Reference `openspec list` or `openspec show <item>` when additional context is required.
6a. Write findings as markdown document to `changes/<id>/review.md` in a section titled Review N, where N is the review number.
6b. If `review.md` already exists, extend the markdown with a new document, Review N+1.
7. Write the recommended fixes as a todo list to `tasks.md`, in a new section named "Review N Findings". Number each task with `RN.X` where N is the review number and X is the task number.
8. You MUST git commit the `review.md` and modified `tasks.md`.

**Reference**
- Use `openspec show <id> --json --deltas-only` if you need additional context from the proposal while reviewing.
