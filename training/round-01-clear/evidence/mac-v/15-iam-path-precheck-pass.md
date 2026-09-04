# B4-1 MAC-V — IAM + Path Precheck PASS

## Scope

This evidence records the read-only IAM and filesystem precheck immediately after the SSH + UFW runtime segment was closed successfully.

## Runtime result

### Mission users

The following users were absent before IAM creation:

- `agent-admin`
- `agent-dev`
- `agent-test`

### Mission groups

The following groups were absent before IAM creation:

- `agent-common`
- `agent-core`

### Mission paths

The following paths were absent before filesystem setup:

- `/opt/agent-app`
- `/opt/agent-app/upload_files`
- `/opt/agent-app/api_keys`
- `/opt/agent-app/bin`
- `/var/log/agent-app`

The corresponding user home directories were also absent:

- `/home/agent-admin`
- `/home/agent-dev`
- `/home/agent-test`

### SSH + UFW regression guard

The already completed network/security segment remained intact during the precheck:

- effective SSH port: `20022`
- effective `PermitRootLogin`: `no`
- UFW: active
- default incoming: deny
- inbound ALLOW ports: `20022/tcp`, `15034/tcp` only (IPv4/IPv6)

## Interpretation

This is a clean IAM baseline. No pre-existing mission users, mission groups, home directories, or Agent filesystem tree need migration or conflict resolution before creation.

## Next gate

Create and verify only the IAM objects first:

- groups: `agent-common`, `agent-core`
- users: `agent-admin`, `agent-dev`, `agent-test`
- `agent-admin`: `agent-common` + `agent-core`
- `agent-dev`: `agent-common` + `agent-core`
- `agent-test`: `agent-common` and **not** `agent-core`

Filesystem/ACL creation remains a later checkpoint.

## Evidence hygiene

- No passwords were created, displayed, or recorded in this precheck.
- No private keys, passphrases, or mission secrets are recorded.

## State

- SSH + UFW segment: PASS
- IAM precheck: PASS
- IAM objects: NOT CREATED
- Agent paths / ACL: NOT CREATED
- Agent runtime / TCP15034: NOT RUN
- B4-1 Mission CLEAR: NO
