---
name: docs-project
description: Docs project - for documentation repositories and doc sites. Writing tasks («Write», «Fix», «Edit»), an outline for larger pieces, judges read the result; no test, security or separate docs phases.
---

# Docs project

For a repository whose product is documentation (a MkDocs, Docusaurus or Sphinx site, a handbook, API guides).

- The implement phase is the writing: titled «Write» (features: new pages), «Fix» (bugs: wrong or outdated
  content) and «Edit» (changes: restructuring, renames, updates for a new version).
- M and L get an «Outline» first (the design phase): M like a plan, L approved by you.
- Judges on the writing: none for S bugs and changes, one otherwise, two of another model family for L features;
  L outlines get a judge and your approval.
- Research when the content needs it (a feature or a version to document); the licence check only when
  dependencies change (the site generator's packages).
- Larger size limits than code (S: 10 files / 400 lines, M: 40 files / 3000 lines); sensitive paths are the site's
  configuration, CI, redirects, CODEOWNERS and the licence.
- «Ask me» path groups (`ask_me`): only «site deployment and CI» and «dependency manifests» - a story touching
  them waits for your acceptance whatever its size; the code-oriented groups (money and auth, migrations,
  production data) don't apply to a docs site.

The import compares it with «Coda complex»: spec, test, security and docs phases are off by design.
