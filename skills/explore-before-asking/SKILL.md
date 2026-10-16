---
name: explore-before-asking
description: Gather evidence from the repository, logs, errors and recent changes before asking anyone a question, then ask only for what cannot be found. Use when interviewing a user, receiving an unclear or underspecified request, or starting on a bug report with missing details.
---

# Explore Before Asking

Questions cost the other side time. Answer everything you can yourself first,
then ask only for what evidence cannot give you.

## 1. Explore first

Before the first question, spend a short, bounded effort on evidence:

- Read the repository: README, docs, build files, entry points, the code the
  request touches, existing tests for it.
- Check recent changes: `git log --oneline -20`, `git log -p -- <path>`,
  open branches, recent diffs near the affected area.
- Read logs, stack traces, error messages and CI output that were provided
  or are available in the workspace.
- For a bug: try to reproduce it. Note the exact command, input and output.
- Search for prior art: similar features, config flags, TODOs, issues.

Stop exploring when further reading no longer changes what you would ask.

## 2. Sort what is still open

Split remaining unknowns into two groups:

- **Observations**: facts only someone else has (what they saw, which
  environment, expected vs. actual behavior, data you cannot access).
- **Decisions**: choices that belong to the requester (scope, trade-offs,
  priorities, naming, compatibility).

Drop anything you already answered from evidence. Do not ask for things you
could look up.

## 3. Ask one question at a time

- One question per message. Most important first: the one whose answer
  changes the most downstream work.
- State briefly what you already found, so the question has context.
- For decisions, offer options and mark one as recommended with a one-line
  reason. Example:

  ```
  Found: retries are hardcoded to 3 in client.go:42; no config exists.
  Question: should retry count become configurable?
  - A (recommended): env var HTTP_RETRIES, default 3 - smallest change.
  - B: config file entry - consistent with timeouts, more work.
  - C: keep hardcoded.
  ```

- For observations, ask for the specific artifact: "Paste the full error
  from the second run", not "Can you tell me more?"

## 4. When nobody can answer

If the requester is unavailable, a deadline is near, or the question is
non-blocking, do not stall. Record the choice and continue:

```
ASSUMPTION: retry count stays hardcoded at 3 (no config requested).
ASSUMPTION: only Linux is supported; no Windows path handling.
```

- Pick the option you would have recommended.
- Put `ASSUMPTION:` lines where the team will see them: the task notes,
  the plan, or the report file.
- Prefer reversible assumptions; flag irreversible ones as blocking instead.

## 5. Know when to stop

You have enough information when there are no open decisions: every
decision is either answered or recorded as an `ASSUMPTION:`, and every
missing observation is either obtained or explicitly not needed.

At that point stop asking and summarize:

- What you found (evidence, with paths or commands).
- What was decided and by whom.
- The `ASSUMPTION:` list.
- The next step you will take.

## Do not

- Ask a list of ten questions at once.
- Ask what the code, logs or git history already answer.
- Ask open-ended questions without a recommended option.
- Block on a non-critical question when an assumption would do.
