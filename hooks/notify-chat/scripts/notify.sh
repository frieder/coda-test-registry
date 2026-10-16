#!/usr/bin/env bash
# Hook: posts "an agent waits for you" to a chat webhook (Slack / Teams). The URL comes from CHAT_WEBHOOK_URL.
set -uo pipefail
if [ -z "${CHAT_WEBHOOK_URL:-}" ]; then
  echo "CHAT_WEBHOOK_URL is not set - nothing sent"
  exit 0
fi
case "${CODA_EVENT:-}" in
  permission) what="waits for your Allow / Deny" ;;
  *) what="asks" ;;
esac
text="Coda · ${CODA_PROJECT_NAME:-${CODA_PROJECT:-?}}: ${CODA_AGENT:-an agent} (${CODA_CLI:-?}) ${what}: ${CODA_MESSAGE:-}"
# JSON-escape: backslashes, quotes, then newlines and tabs as spaces
esc=$(printf '%s' "$text" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n\t\r' '   ')
payload=$(printf '{"text": "%s"}' "$esc")
curl -fsS --max-time 15 -X POST -H 'Content-Type: application/json' --data "$payload" "$CHAT_WEBHOOK_URL" >/dev/null
echo "sent to the chat webhook"
