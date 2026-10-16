# zz-unsupported-sse (TEST ITEM)

A server.json whose only remote uses the old SSE transport. Coda runs local stdio packages and streamable-HTTP
remotes only, so «From a registry…» lists it with the problem
"nothing Coda can run yet: remote type sse (Coda takes streamable HTTP)" and it can't be imported.
The URL is on `example.invalid`, which never resolves.
