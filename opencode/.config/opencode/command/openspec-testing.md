---
agent: general
description: Generate an interactive testing session to manually validate an OpenSpec change.
---
The user has requested a testing guide for the following change proposal.
<UserRequest>
  $ARGUMENTS
</UserRequest>

**Guardrails**
- You MUST read `openspec/AGENTS.md` for further guidance before proceeding.
- Focus on manual validation steps that a human can execute to verify the implementation.
- Provide specific commands, expected outputs, and validation criteria.
- Do NOT run any commands yourself - this is a guide for human testers.

**Steps**
Track these steps as TODOs and complete them one by one.
1. Read `changes/<id>/proposal.md` to understand the change objectives and user-facing impact.
2. Read `changes/<id>/design.md` (if present) to understand architectural decisions and system interactions.
3. Read `changes/<id>/tasks.md` to identify what was implemented and what remains incomplete.
4. Review `changes/<id>/specs/*/spec.md` to understand the requirements and scenarios that need validation.
5. Explore the implemented code to understand entry points, CLI commands, APIs, or user workflows affected.
6. Create an interactive testing guide that includes:
   - **Setup Prerequisites**: Environment requirements, build steps, data preparation
   - **Test Scenarios**: Step-by-step instructions organized by capability or requirement
   - **Commands to Run**: Exact commands with parameters the user should execute
   - **Expected Outputs**: What the user should see/observe at each step
   - **Validation Criteria**: How to determine if behavior matches the spec
   - **Edge Cases**: Boundary conditions, error scenarios, and negative tests
   - **Cleanup**: Steps to reset state between tests if needed
7. Present the testing guide to the user in a clear, structured format with numbered steps.
8. Ask the user if they would like you to adjust the testing plan (add scenarios, simplify, focus on specific areas).

**Format Guidelines**
Structure the testing guide as follows:

```markdown
# Manual Testing Guide: [Change Title]

## Overview
[Brief description of what this change does and what we're validating]

## Prerequisites
- [ ] [Build/setup requirement 1]
- [ ] [Build/setup requirement 2]

## Test Scenario 1: [Scenario Name]
**Validates**: [Requirement name from spec]

### Steps
1. [Action to perform]
   ```bash
   [exact command]
   ```

2. **Expected Result**: [What should happen]
   [Expected output or behavior]

3. **Validation**: [How to verify success]
   - [ ] [Check 1]
   - [ ] [Check 2]

## Test Scenario 2: [Scenario Name]
[Continue pattern...]

## Edge Cases
[Test error handling, boundaries, etc.]

## Cleanup
[How to reset environment if needed]
```

**Reference**
- Use `openspec show <id> --json --deltas-only` to inspect spec requirements and scenarios.
- Use `rg` or file exploration to find relevant code entry points (main.go, CLI commands, API handlers).
- Focus on scenarios defined in spec deltas - each `#### Scenario:` should map to a test case.
