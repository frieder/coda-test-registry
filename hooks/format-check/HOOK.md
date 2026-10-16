---
name: format-check
description: After a worker's successful turn, checks the formatting of the files changed in the project folder (gofmt, Prettier, Black, terraform fmt - whichever the project has) and fails with the list when one needs formatting.
event: turn_ended
match:
  roles: [worker]
  outcomes: [success]
action:
  type: command
  run: scripts/format-check.sh
timeout: 60
---

# Format check

Runs after every successful worker turn and checks only the files that differ from `HEAD` in the project folder
(changed, staged or new), with the formatters the project already has:

| Files | Check | Runs when |
|---|---|---|
| `*.go` | `gofmt -l` | `gofmt` is on the PATH |
| `*.js *.jsx *.ts *.tsx *.css *.scss *.json *.md *.html` | `prettier --check` | `node_modules/.bin/prettier` exists |
| `*.py` | `black --check` | `black` is on the PATH |
| `*.tf` | `terraform fmt -check` | `terraform` is on the PATH |

It changes nothing. When a file needs formatting the hook **fails**: the Log has a `hook_failed` line with the
files, and «Project → Hooks» shows the last run as failed. The same list is appended to `.coda/format-check.log`.

In full projects the workers work in their own worktrees, so the project folder only shows what was integrated;
the hook is most useful in light projects. Formatters that aren't installed are skipped (never downloaded).
