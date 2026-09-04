# B4-1 MAC-V — Secret File Policy PASS

## Scope

This evidence records the MAC-V runtime preparation and policy verification of the B4-1 mission Secret file after the shared filesystem and ACL policy had already passed.

## Runtime result

- Root context was used through the local OrbStack control path because the normal Ubuntu account did not have a configured sudo password.
- Secret path: `/opt/agent-app/api_keys/t_secret.key`
- The Secret value itself was entered locally with hidden terminal input.
- The Secret value was not displayed, copied to chat, or recorded in GitHub/Evidence.
- Secret file exists and is non-empty.
- Owner: `agent-admin`
- Group: `agent-core`
- Mode: `0660`

## Effective access

- `agent-admin`: read/write PASS
- `agent-dev`: read/write PASS
- `agent-test`: read/write DENY PASS

Final runtime gate:

- `[PASS] Secret owner = agent-admin`
- `[PASS] Secret group = agent-core`
- `[PASS] Secret mode = 660`
- `[PASS] B4-1 SECRET FILE POLICY`

## Evidence hygiene

The following are intentionally not recorded:

- Secret value
- Ubuntu/root passwords
- SSH private key or passphrase
- client IP / ephemeral source port

The exact Secret value is not verified by printing or comparing it. Its correctness remains to be validated indirectly by the provided Agent Boot Sequence in the next runtime phase.

## State

- SSH + UFW segment: PASS
- IAM membership: PASS
- Filesystem + ACL: PASS
- Secret file policy: PASS
- Agent binary/env installation: NOT RUN
- Agent Boot / TCP15034: NOT RUN
- B4-1 Mission CLEAR: NO
