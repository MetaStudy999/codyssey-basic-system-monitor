# B4-1 MAC-V — Agent Binary + Environment Install PASS

## Scope

This evidence records the MAC-V runtime installation and verification of the canonical B4-1 Agent binary and the non-secret runtime environment file after the Agent archive/CPU precheck and Secret policy had passed.

## Runtime result

- Provided archive source: `agent-app.zip`
- Host architecture: `x86_64`
- Selected supplied binary: `agent-app-linux-x86`
- Selected source identified as an x86-64 ELF executable.
- Canonical Agent path: `/opt/agent-app/bin/agent-app`
- Canonical Agent owner: `agent-admin`
- Canonical Agent group: `agent-core`
- Canonical Agent mode: `0750`
- Canonical Agent installed successfully.

## Non-secret environment

`/opt/agent-app/env.sh` was created with the expected non-secret runtime variables:

- `AGENT_HOME=/opt/agent-app`
- `AGENT_PORT=15034`
- `AGENT_UPLOAD_DIR=/opt/agent-app/upload_files`
- `AGENT_KEY_PATH=/opt/agent-app/api_keys/t_secret.key`
- `AGENT_LOG_DIR=/var/log/agent-app`
- `AGENT_PROCESS_NAME=agent-app`

Environment file policy:

- Owner: `agent-admin`
- Group: `agent-core`
- Mode: `0640`
- Bash syntax validation: PASS
- `agent-admin` source + expected variable validation: PASS

## Effective access

- `agent-admin`: Agent binary read/execute PASS; `env.sh` read PASS
- `agent-dev`: Agent binary read/execute PASS; `env.sh` read PASS
- `agent-test`: Agent binary execute DENY PASS; `env.sh` read DENY PASS

## Secret regression guard

- Secret file remained present and non-empty.
- Owner remained `agent-admin`.
- Group remained `agent-core`.
- Mode remained `0660`.
- Secret value itself was not read, displayed, copied, or recorded.

## Cleanup

- Unique temporary install directory was removed safely after installation.

## Final gate

- `[PASS] canonical Agent binary installed`
- `[PASS] non-secret env.sh installed`
- `[PASS] role-based access verified`
- `[PASS] Secret preserved without reading value`
- `[PASS] B4-1 AGENT BINARY + ENV INSTALL`

## State

- SSH + UFW: PASS
- IAM membership: PASS
- Filesystem + ACL: PASS
- Secret file policy: PASS
- Agent archive + CPU precheck: PASS
- Agent binary + env installation: PASS
- Agent Boot 5/5: NOT RUN
- `Agent READY`: NOT RUN
- TCP `0.0.0.0:15034` LISTEN: NOT RUN
- B4-1 Mission CLEAR: NO
