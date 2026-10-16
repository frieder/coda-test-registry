---
name: zz-invalid-policy
description: TEST ITEM - a policy with an event Coda doesn't know (net.teleport), to see the import's validation. It can't be imported.
---

# Test item: invalid policy

`policy.json` is valid JSON, but one of its options names the event `net.teleport`, which isn't in Coda's
catalogue of security events. The registry list shows this policy as invalid with that error, and it can't be
imported.
