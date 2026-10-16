---
name: bugfix-first
description: Bugfix first - for maintenance projects. Every bug starts with a failing test that a judge checks, every fix is judged, a regression test from M; new features always need your acceptance.
---

# Bugfix first

For a product in maintenance, where most stories are bugs and new behaviour should be rare and deliberate.
Compared with «Coda lean»:

- **Bugs:** reproduce (a failing test) with one judge at every size; the fix always has a judge; M adds a
  regression test task after the fix; L adds a design you approve, two judges of another model family and a
  security review when sensitive paths are touched.
- **Features:** accepted by **you** at every size (S and M too) - scope creep stays visible.
- **Changes:** the current behaviour is pinned first (characterize) at every size, then the change; judged.
- No Lead Architect: disputes come to you. At most 2 tasks of a story at a time.

The import compares it with «Coda complex»: some phases and reviews are off (e.g. no spec for M features, no
security review below L), which the import dialog lists.
