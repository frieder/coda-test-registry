---
name: zz-unavailable-model
description: TEST ITEM - a valid definition naming a model no machine has (claude-imaginary-9-preview), so the import shows "model not available on this machine".
---

# Test item: a model this machine doesn't have

The JSON is valid and Claude Code is a known CLI, but the model `claude-imaginary-9-preview` doesn't exist.
The import dialog should show that the model isn't available on this machine (a note, not an error): the
definition can still be imported, and an agent started from it would fail until the model is changed.
