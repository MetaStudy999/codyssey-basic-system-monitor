# B4-1 MAC-V — Agent Runtime Preflight PASS

## Scope

This evidence records the read-only runtime preflight immediately before the first foreground launch of the provided B4-1 Agent.

## Runtime result

- Control context: local OrbStack Ubuntu root shell used only for privileged inspection/control.
- Canonical Agent binary exists at `/opt/agent-app/bin/agent-app`.
- Agent binary metadata: owner `agent-admin`, group `agent-core`, mode `0750`.
- `env.sh` metadata: owner `agent-admin`, group `agent-core`, mode `0640`.
- Secret file metadata: owner `agent-admin`, group `agent-core`, mode `0660`.
- Secret file is non-empty; value was not read or displayed.
- `agent-admin` resolves to non-root UID `1005`.
- `agent-admin` can source the expected non-secret runtime environment.
- `agent-admin` can execute the Agent binary.
- `agent-admin` can write `/var/log/agent-app`.
- Existing `agent-app` process count before launch: `0`.
- TCP `15034` was free before launch.
- UFW remained active with inbound ALLOW only for `20022/tcp` and `15034/tcp` (IPv4/IPv6).

## Preflight gates

- `[PASS] Agent binary executable`
- `[PASS] Secret non-empty — content NOT read`
- `[PASS] agent-admin is non-root uid=1005`
- `[PASS] agent-admin runtime environment`
- `[PASS] agent-admin can execute Agent`
- `[PASS] agent-admin can write Agent log directory`
- `[PASS] no existing agent-app process`
- `[PASS] TCP15034 currently free`

## Evidence hygiene

The following are intentionally not recorded:

- Secret value
- passwords
- SSH private key or passphrase
- unrelated process/environment data

## State

- SSH + UFW: PASS
- IAM membership: PASS
- Filesystem + ACL: PASS
- Secret file policy: PASS
- Agent binary + env installation: PASS
- Agent runtime preflight: PASS
- Agent Boot Sequence 5/5: NOT RUN
- `Agent READY`: NOT RUN
- `0.0.0.0:15034` LISTEN: NOT RUN
- B4-1 Mission CLEAR: NO
