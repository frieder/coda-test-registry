---
name: release-prep
description: Prepares a release on a branch - release notes from the Git history, the version bumped where the project keeps it, the checks run - and stops before tagging or pushing.
version: "1.0"
inputs:
  version: {type: text, label: "New version (e.g. 2.4.0)", required: true}
  since: {type: date, default: today-14d, label: "Changes since", required: true}
  branch: {type: git branch, label: "Release branch", required: true}
  notes_file: {type: file, label: "Release notes file", default: CHANGELOG.md}
  audience: {type: radio, options: [users, developers], default: users, label: "Notes written for"}
done_when:
  - The release notes list every user-visible change of the period, grouped Added / Changed / Fixed.
  - The project's build and tests pass on the release branch.
  - Nothing was tagged or pushed.
---

Prepare release **{version}** on branch `{branch}`.

1. List the changes: `git log {branch} --since={since} --no-merges --oneline`, plus merged pull requests if the
   project's history uses them. Leave out pure refactors, CI and test-only changes unless they matter to
   {audience}.
2. Write the release notes for {audience} at the top of `{notes_file}`: a heading with {version} and today's date,
   then **Added**, **Changed**, **Fixed** (empty groups left out), one short line per change.
3. Bump the version to {version} where the project keeps it (package.json, pom.xml, version.go, pyproject.toml,
   a VERSION file …). Change nothing else.
4. Run the project's build and tests. If something fails, stop and report it; don't fix unrelated failures.
5. Commit on `{branch}` with the message "Prepare release {version}". **Don't tag and don't push** - the release
   owner does that after reading the notes.

Report: the notes as written, the files you changed, the checks you ran and their result.
