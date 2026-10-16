---
name: notify-chat
description: Posts a short chat message (Slack or Teams incoming webhook) when an agent asks you something or waits for your Allow / Deny. Does nothing until CHAT_WEBHOOK_URL is set in Coda's environment.
events: [question, permission]
action:
  type: command
  run: scripts/notify.sh
timeout: 20
---

# Chat notification

When an agent waits for you, a message like this goes to your team chat:

```
Coda · shop-backend: worker1 (claude) asks: Should the retry count become configurable?
```

**Setup:** create an incoming webhook in Slack (or a Teams workflow webhook) and start Coda with
`CHAT_WEBHOOK_URL=<the webhook URL>` in its environment. Without it the hook prints "CHAT_WEBHOOK_URL is not set"
and exits 0, so it is safe to add before it is configured.

It sends the project's name, the agent, its CLI and the question (Coda's `CODA_MESSAGE`, at most 1000 characters) -
nothing else. Coda's import check marks it **to look at**, because it sends data to a URL: that is what it is for.
