# B4-1 MAC-V — Agent Key Path Runtime Contract Fix PASS

## Scope

This evidence records the first real foreground Agent boot failure, the observed runtime-contract mismatch, and the narrowly scoped `AGENT_KEY_PATH` correction performed before retrying the Agent.

## First foreground boot result

The provided Agent was launched as non-root `agent-admin` (uid `1005`).

Observed boot result:

- `[1/5] Checking User Account [OK]`
- `[2/5] Verifying Environment Variables [FAIL]`
- Agent diagnostic: `Key Path Mismatch. Expected: /opt/agent-app/api_keys`
- Steps 3/5 through 5/5 were skipped because step 2 was a critical failure.
- `Agent READY` was not reached.
- The process terminated normally after the failed boot sequence.

No Secret value was displayed or recorded.

## Contract discrepancy

The preserved Mission/reference material had configured:

`AGENT_KEY_PATH=/opt/agent-app/api_keys/t_secret.key`

The actual provided Agent binary reported that its runtime expectation is:

`AGENT_KEY_PATH=/opt/agent-app/api_keys`

This is treated as a runtime contract discrepancy between the preserved source requirement/reference layer and the actual supplied executable. The original Mission source is not rewritten by this runtime evidence.

## Narrow correction applied

Only the non-secret environment variable was changed:

- before: `/opt/agent-app/api_keys/t_secret.key`
- after: `/opt/agent-app/api_keys`

The Secret file itself remains at:

`/opt/agent-app/api_keys/t_secret.key`

Secret contents were not read or changed.

## Post-fix verification

- no residual `agent-app` process: PASS
- TCP `15034` free: PASS
- `env.sh` owner `agent-admin`, group `agent-core`, mode `0640`: preserved
- modified `env.sh` Bash syntax: PASS
- `agent-admin` runtime environment resolves `AGENT_KEY_PATH=/opt/agent-app/api_keys`: PASS
- Secret file remains non-empty: PASS
- Secret owner `agent-admin`: preserved
- Secret group `agent-core`: preserved
- Secret mode `0660`: preserved
- temporary rollback backup removed after validation: PASS

Final local gate:

- `[PASS] B4-1 AGENT KEY PATH CONTRACT FIX`

## Evidence hygiene

Not recorded:

- Secret value
- passwords
- SSH private key/passphrase
- unrelated environment values

## State

- Agent Runtime Preflight: PASS
- First Agent Boot: FAIL at environment step 2/5 due to key-path contract mismatch
- Key-path runtime correction: PASS / prepared for retry
- Agent Boot Sequence 5/5 after correction: NOT YET VERIFIED
- `Agent READY`: NOT YET VERIFIED
- `0.0.0.0:15034` LISTEN: NOT YET VERIFIED
- B4-1 Mission CLEAR: NO
