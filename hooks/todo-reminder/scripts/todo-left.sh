#!/usr/bin/env bash
# Hook: lists TODO/FIXME/XXX/HACK lines just added (Coda runs it in the project folder). Always exits 0.
set -uo pipefail
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a Git repository"; exit 0; }

if [ "${CODA_EVENT:-}" = "task_done" ]; then
  git rev-parse --verify -q HEAD~1 >/dev/null || { echo "no previous commit"; exit 0; }
  range=(HEAD~1 HEAD)
  who="${CODA_TASK:-task}"
else
  range=(HEAD)
  who="${CODA_AGENT:-agent}"
fi

# "file:line: text" for every added line with a marker
hits=$(git diff --unified=0 --no-color "${range[@]}" 2>/dev/null | awk '
  /^\+\+\+ / { file = substr($0, 7); next }
  /^@@ / { split($3, a, ","); line = substr(a[1], 2) + 0; next }
  /^\+/ { if ($0 ~ /(TODO|FIXME|XXX|HACK)([:( ]|$)/) printf "%s:%d: %s\n", file, line, substr($0, 2); line++; next }
')

if [ -z "$hits" ]; then
  echo "no new TODO lines"
  exit 0
fi
n=$(printf '%s\n' "$hits" | wc -l | tr -d ' ')
mkdir -p .coda
{ printf '%s  %s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "${CODA_EVENT:-?}" "$who"
  printf '%s\n' "$hits" | sed 's/^/  /'; } >> .coda/todo-reminder.log
echo "$n new TODO line(s) - see .coda/todo-reminder.log"
printf '%s\n' "$hits" | head -5
exit 0
