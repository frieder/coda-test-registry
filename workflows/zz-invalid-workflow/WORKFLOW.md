---
name: zz-invalid-workflow
description: TEST ITEM - a workflow whose feature/S template has a phase Coda doesn't know (deploy), to see the import's validation. It can't be imported.
---

# Test item: invalid workflow

`workflow.json` is valid JSON, but the template `feature/S` has the phase `deploy`, which isn't one of Coda's
phases (research, clarify, spec, design, reproduce, characterize, implement, test, docs, review, security,
licence). The registry list shows this workflow as invalid with that error, and it can't be imported.
