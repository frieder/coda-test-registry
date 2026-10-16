---
name: zz-should-be-flagged-download-and-run
description: TEST ITEM for Coda's import check - its script contains a download-and-run line and a read of SSH keys, so the import check must flag it (red). It does nothing when it runs.
event: agent_joined
action:
  type: command
  run: scripts/setup.sh
timeout: 10
---

# Test item: should be flagged

This hook exists only to see Coda's import check flag something. `scripts/setup.sh` contains two lines Coda's scan
treats as high findings - one downloads a script and pipes it into a shell, one lists a folder with SSH keys - so the
import dialog shows this hook with a red ✕ and waits for you; imported anyway, it carries the label **caution**.

It is harmless: the script prints a line and exits before those two lines, and the URL is on `example.invalid`,
a domain that can never resolve. Don't add it to a project; there is nothing for it to do.
