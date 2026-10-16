---
name: commit-hygiene
description: Make small, focused commits with clear messages, check staged changes before committing, keep secrets and generated files out, and never rewrite shared history or push unless told. Use whenever creating commits, staging changes or preparing work for review.
---

# Commit Hygiene

Each commit should be easy to review, easy to revert and safe to share.

## 1. Keep commits small and focused

- One logical change per commit: a fix, a feature step, a refactor, a test.
- Do not mix refactors or formatting with behavior changes.
- Stage selectively: `git add <paths>` or `git add -p`. Avoid `git add -A`
  and `git add .` unless you have checked every file.
- Commit only the files your task is meant to change.

## 2. Check before committing

Always run, in this order:

```
git status
git diff --staged
```

Confirm that the staged diff:

- Contains only the intended change.
- Has no secrets: API keys, tokens, passwords, private keys, `.env` files,
  credentials in URLs or config.
- Has no generated junk: build output, `node_modules/`, `vendor/` (unless
  the project commits it), binaries, coverage reports, `*.log`, editor and
  OS files (`.idea/`, `.vscode/`, `.DS_Store`), temporary files.
- Has no debug leftovers: print statements, commented-out code, focused or
  skipped tests.

If something should never be committed, add it to `.gitignore` only if your
task allows changing that file; otherwise mention it in your report.

Run the project's tests or at least the build for the touched area before
committing.

## 3. Message format

```
Add configurable retry count to HTTP client

Retries were hardcoded to 3, which is too low for the flaky staging
proxy. Read HTTP_RETRIES from the environment, default 3, and reject
values below 0.

Refs: #123
```

- Subject: imperative mood ("Add", "Fix", "Remove", not "Added" or
  "Fixes"), at most 72 characters, no trailing period.
- Blank line, then a body that explains why the change is needed and any
  non-obvious decisions. The diff already shows what changed.
- Reference the task or issue id if the project uses them.
- Follow the project's existing convention (e.g. Conventional Commits) if
  one is visible in `git log`.

## 4. History and remotes

- Never rewrite shared history: no `rebase`, `commit --amend`, `reset` or
  `push --force` on commits that others may have pulled.
- Amending or squashing your own unpushed local commits is fine.
- Never push unless explicitly told to. When told, push only the named
  branch, never with `--force` unless explicitly told that too.
- Do not change git config, hooks or remotes.
- If a secret was already committed, stop and report it. Removing it from
  history requires rotation and a human decision.

## Do not

- Commit with `--no-verify` to bypass hooks.
- Write messages like "fix", "wip", "update files" or "changes".
- Commit on the default branch if the task says to use a branch.
