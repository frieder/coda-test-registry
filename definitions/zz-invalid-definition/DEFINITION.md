---
name: zz-invalid-definition
description: TEST ITEM - a definition whose definition.json is broken JSON (a trailing comma), to see the import's validation. It can't be imported.
---

# Test item: broken JSON

`definition.json` ends its object with a trailing comma, which JSON doesn't allow. The registry list shows this
definition as invalid with the JSON error, and it can't be imported.
