---
name: relaxed-prototypes
description: Relaxed for prototypes. Fewer questions for throw-away prototypes on your own machine - local deletes, discarding work, push, download-and-run, local database resets and CI edits are allowed; what can't be undone stays denied.
---

# Relaxed for prototypes

For a prototype or spike that lives on a branch nobody else uses, where Coda's questions slow you down more than
they protect you. Allowed here (Coda default asks):

- deleting git-ignored files, discarding uncommitted work;
- push (to your own branch - force push stays denied);
- download-and-run (`npx` of a new tool, an install script);
- writing `.env` and other secret files, running migrations, destructive commands on a **local** database;
- editing CI pipelines; calling MCP servers' tools.

Still denied as in Coda default: force push, deleting outside the project, publishing packages, remote databases,
destroying infrastructure, and every locked event.

**The import shows its events looser than Coda default** - that is expected for this policy. Don't use it for
projects with real data or shared branches.
