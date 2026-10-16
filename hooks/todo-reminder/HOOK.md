---
name: todo-reminder
description: Lists the TODO, FIXME, XXX and HACK lines an agent just added - after a worker's successful turn (light projects) or when a task is done (full projects) - in .coda/todo-reminder.log. A reminder only; it never fails a turn.
events: [turn_ended, task_done]
match:
  outcomes: [success]
action:
  type: command
  run: scripts/todo-left.sh
timeout: 30
---

# "No TODO left" reminder

Agents like to leave `TODO: handle errors` behind. This hook shows you where:

- **`turn_ended`** (a successful turn): the lines added in the project folder's uncommitted changes
  (`git diff HEAD`) - what an agent in a light project just wrote.
- **`task_done`** (full projects; a task is done once it is integrated): the lines added by the last commit
  (`HEAD~1..HEAD`).

Each hit is appended to `.coda/todo-reminder.log` with the agent or task, file and line:

```
2026-10-16 14:03:11  turn_ended  worker1
  src/client.go:88: // TODO: retry on 503
```

The run's output (the end is in the Log's `hook_ran` line) says "2 new TODO lines" or "no new TODO lines". It always
exits 0: a reminder, not a gate. Add `.coda/*.log` to `.gitignore` to keep the log out of Git.
