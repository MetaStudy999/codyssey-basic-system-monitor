# B4-1 MAC-V — IAM Membership PASS

## Scope

This evidence records creation and verification of the B4-1 mission users, groups, and exact group-membership policy on the MAC-V runtime.

## Runtime result

Mission groups created:

- `agent-common`
- `agent-core`

Mission users created with home directories and `/bin/bash` shells:

- `agent-admin`
- `agent-dev`
- `agent-test`

Verified membership policy:

- `agent-admin` = primary group `agent-admin` + `agent-common` + `agent-core`
- `agent-dev` = primary group `agent-dev` + `agent-common` + `agent-core`
- `agent-test` = primary group `agent-test` + `agent-common`
- `agent-test` is not a member of `agent-core`

Final runtime markers:

- `[PASS] agent-admin = common + core`
- `[PASS] agent-dev   = common + core`
- `[PASS] agent-test  = common only`
- `[PASS] B4-1 IAM MEMBERSHIP`

## Home directory state

The three user home directories were created by `useradd --create-home` and verified as owned by their corresponding users. No mission application tree under `/opt/agent-app` was created in this checkpoint.

## Regression guard

After IAM creation:

- effective SSH port remained `20022`
- effective `PermitRootLogin` remained `no`
- UFW remained active
- inbound ALLOW remained limited to `20022/tcp` and `15034/tcp` for IPv4/IPv6

## State boundary

This checkpoint proves only users, groups, and membership.

Still not completed here:

- `/opt/agent-app` shared tree
- `/var/log/agent-app`
- ACL / effective least-privilege access
- Secret file
- Agent runtime / TCP 15034
- monitor / cron / log rotation
- final verification

B4-1 Mission CLEAR: **NO**.

## Evidence hygiene

No passwords, private keys, passphrases, mission secret values, client IPs, or ephemeral ports are recorded.
