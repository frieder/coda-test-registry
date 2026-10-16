---
name: test-first-bugfix
description: Fix a bug by first reproducing it with a failing automated test (or using one someone already wrote for it), then finding the root cause and applying the smallest fix that makes the test pass. Use when assigned a bug, regression, failing behavior or error report that needs a code fix.
---

# Test-First Bugfix

No fix without a failing test first. The test proves the bug exists, proves
the fix works, and keeps it from coming back.

If someone already reproduced the bug (a failing test, perhaps with likely
causes), read it, confirm the test still fails, and start at step 3.

## 1. Understand the report

- Collect the exact symptom: input, expected result, actual result, error
  text, environment.
- Check recent changes in the affected area: `git log -p -- <path>`.
- If the symptom is unclear, reproduce manually before writing any test.

## 2. Write a failing test

- Put the test next to the existing tests for that code, using the
  project's test framework and conventions.
- Make it as small as possible: the minimal input that triggers the bug.
- Name it after the behavior, e.g. `TestParseDuration_EmptyStringReturnsError`.
- Run it and confirm it fails for the right reason (the bug's symptom, not a
  typo, missing import or setup error).
- If you cannot reproduce in a test, stop and report what you tried. Do not
  guess-fix.

## 3. Find the root cause

- Trace from the failing assertion back to where the wrong value or state is
  first produced.
- Ask "why" until you reach the actual defect, not just where it surfaces.
- Check whether the same defect exists in sibling code paths (copied
  logic, other callers). Note them; fix them only if in scope.

## 4. Apply the minimal fix

- Change only what the root cause requires. No refactors, renames or
  unrelated cleanups in the same change.
- Do not weaken or delete the new test, or other tests, to make things pass.
- Keep public behavior unchanged except for the bug.

## 5. Verify

- Run the new test: it passes.
- Run the related suite (package, module, or the tests covering the touched
  files). Then run the broader suite if it is fast enough.
- Run the build and linter the project uses.
- Temporarily revert the fix and confirm the test fails again, if cheap.

## 6. Report

Keep it short and concrete:

```
Bug: ParseDuration("") panicked with index out of range.
Root cause: duration.go:31 indexes s[0] before the length check.
Fix: length check moved before indexing (duration.go:28-33).
Test: TestParseDuration_EmptyStringReturnsError (fails before, passes after).
Checked: go test ./internal/config/... ; go vet ./...
Not checked: full integration suite (needs DB); other callers of s[0] in
  parse_size.go:14 look similar but untested.
```

Always include a "Not checked" line. Say so explicitly if it is empty.

## Do not

- Fix first and add a test afterwards that was never seen failing.
- Mark a test as skipped or flaky to get green.
- Bundle the fix with unrelated changes.
- Claim "fixed" without running the related suite.
