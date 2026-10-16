#!/usr/bin/env bash
# Hook: checks the formatting of the files changed in the project folder (Coda runs it there). Changes nothing.
set -uo pipefail
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a Git repository - nothing to check"; exit 0; }

# changed, staged and new files that still exist
files=$( { git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard; } | sort -u)
[ -n "$files" ] || { echo "no changed files"; exit 0; }

bad=""
pick() { printf '%s\n' "$files" | grep -E "$1" | while IFS= read -r f; do [ -f "$f" ] && printf '%s\n' "$f"; done; }

go_files=$(pick '\.go$')
if [ -n "$go_files" ] && command -v gofmt >/dev/null; then
  out=$(printf '%s\n' "$go_files" | xargs gofmt -l 2>/dev/null)
  [ -n "$out" ] && bad="$bad$out"$'\n'
fi

web_files=$(pick '\.(js|jsx|ts|tsx|css|scss|json|md|html)$')
if [ -n "$web_files" ] && [ -x node_modules/.bin/prettier ]; then
  out=$(printf '%s\n' "$web_files" | xargs node_modules/.bin/prettier --list-different 2>/dev/null)
  [ -n "$out" ] && bad="$bad$out"$'\n'
fi

py_files=$(pick '\.py$')
if [ -n "$py_files" ] && command -v black >/dev/null; then
  out=$(printf '%s\n' "$py_files" | xargs black --check --quiet 2>&1 | sed -n 's/^would reformat //p')
  [ -n "$out" ] && bad="$bad$out"$'\n'
fi

tf_files=$(pick '\.tf$')
if [ -n "$tf_files" ] && command -v terraform >/dev/null; then
  for f in $tf_files; do terraform fmt -check "$f" >/dev/null 2>&1 || bad="$bad$f"$'\n'; done
fi

if [ -z "$bad" ]; then
  echo "formatting ok"
  exit 0
fi
mkdir -p .coda
{ printf '%s  %s (%s): needs formatting\n' "$(date '+%Y-%m-%d %H:%M:%S')" "${CODA_AGENT:-?}" "${CODA_CLI:-?}"
  printf '%s' "$bad" | sed '/^$/d; s/^/  /'; } >> .coda/format-check.log
echo "needs formatting:"
printf '%s' "$bad" | sed '/^$/d'
exit 1
