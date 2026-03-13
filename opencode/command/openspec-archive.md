---
agent: build
description: Archive a deployed OpenSpec change and update specs.
---
The user has requested to archive the following change proposal.
<UserRequest>
  $ARGUMENTS
</UserRequest>

**Guardrails**
- Favor straightforward, minimal implementations first and add complexity only when it is requested or clearly required.
- Keep changes tightly scoped to the requested outcome.
- You MUST read `openspec/AGENTS.md` for further guidance before proceeding.

**Pre-flight**
1. Identify the requested change ID (via the prompt or `openspec list`).
2. Ensure the file `review.md` is present in the change directory, which indicates code review is complete. If missing, ABORT the archive. There is one exception to this rule: when the proposal affects ONLY specs, with no code changes. In this case, a review is not needed.

**Steps**
1. Run `openspec archive <id> --yes` to let the CLI move the change and apply spec updates without prompts (use `--skip-specs` only for tooling-only work).
2. Review the command output to confirm the target specs were updated and the change landed in `changes/archive/`.
3. Validate with `openspec validate --strict` and inspect with `openspec show <id>` if anything looks off.
4. Create a git commit containing just the archived proposal files.

**Reference**
- Inspect refreshed specs with `openspec list --specs` and address any validation issues before handing off.
