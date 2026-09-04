# B4-1 MAC-V — Secret Filename Runtime Compatibility PASS

## Scope

This evidence records the second real Agent boot failure at Required Files step 3/5 and the narrowly scoped runtime compatibility fix for the Secret filename.

## Second foreground boot result

The provided Agent was launched as non-root `agent-admin` after the prior `AGENT_KEY_PATH` correction.

Observed boot result:

- `[1/5] Checking User Account [OK]`
- `[2/5] Verifying Environment Variables [OK]`
- `[3/5] Checking Required Files [FAIL]`
- Agent diagnostic: `Missing File: secret.key`
- Agent expected location: `/opt/agent-app/api_keys/secret.key`
- Steps 4/5 and 5/5 were skipped because step 3 was a critical failure.
- `Agent READY` was not reached.

No Secret value was displayed or recorded.

## Runtime compatibility discrepancy

The preserved Mission/reference layer uses the canonical Secret path:

`/opt/agent-app/api_keys/t_secret.key`

The actual provided Agent binary, after accepting `AGENT_KEY_PATH=/opt/agent-app/api_keys`, requires a file named:

`/opt/agent-app/api_keys/secret.key`

The canonical Mission/reference Secret filename is preserved. The runtime compatibility layer adds a second filename that references the same underlying inode.

## Compatibility fix applied

- canonical file retained: `/opt/agent-app/api_keys/t_secret.key`
- runtime compatibility name created: `/opt/agent-app/api_keys/secret.key`
- implementation: hard link, not a content copy
- both names resolve to the same device/inode
- both names report link count `2`
- Secret contents were not read, displayed, duplicated into evidence, or re-entered

## Post-fix verification

- no residual `agent-app` process: PASS
- TCP `15034` free: PASS
- canonical `t_secret.key` exists and is non-empty: PASS
- canonical owner `agent-admin`: PASS
- canonical group `agent-core`: PASS
- canonical mode `0660`: PASS
- `secret.key` did not exist before creation: PASS
- hard-link creation: PASS
- `t_secret.key` and `secret.key` same inode: PASS
- `agent-admin` read/write runtime Secret: PASS
- `agent-dev` read/write runtime Secret: PASS
- `agent-test` read/write runtime Secret: DENY / PASS
- `AGENT_KEY_PATH=/opt/agent-app/api_keys` preserved: PASS

Final local gate:

- `[PASS] B4-1 SECRET FILENAME RUNTIME COMPATIBILITY FIX`

## Evidence hygiene

Not recorded:

- Secret value
- passwords
- SSH private key/passphrase
- unrelated environment data

## State

- Agent Runtime Preflight: PASS
- Boot attempt 1: FAIL at 2/5, key-path mismatch diagnosed and fixed
- Boot attempt 2: 1/5 PASS, 2/5 PASS, 3/5 FAIL due runtime filename mismatch
- Secret filename runtime compatibility: PASS / prepared for retry
- Agent Boot Sequence 5/5 after compatibility fix: NOT YET VERIFIED
- `Agent READY`: NOT YET VERIFIED
- `0.0.0.0:15034` LISTEN: NOT YET VERIFIED
- B4-1 Mission CLEAR: NO
