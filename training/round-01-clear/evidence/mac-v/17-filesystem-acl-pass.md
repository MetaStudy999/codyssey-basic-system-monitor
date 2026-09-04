# B4-1 MAC-V — Filesystem + ACL PASS

## Scope

This evidence records the actual MAC-V runtime construction and effective-access verification of the B4-1 shared Agent filesystem tree after IAM membership had already passed.

## Runtime result

The following paths were created with the R01 Golden Path ownership and modes:

- `/opt/agent-app` → `agent-admin:agent-common`, mode `0710`
- `/opt/agent-app/upload_files` → `agent-admin:agent-common`, mode `2770`
- `/opt/agent-app/api_keys` → `agent-admin:agent-core`, mode `2770`
- `/opt/agent-app/bin` → `agent-dev:agent-core`, mode `0750`
- `/var/log/agent-app` → `agent-admin:agent-core`, mode `2770`

ACL and default ACL were applied to the shared writable directories:

- `upload_files`: `agent-common:rwx`
- `api_keys`: `agent-core:rwx`
- `/var/log/agent-app`: `agent-core:rwx`
- ACL masks were `rwx`
- `other::---`

## Effective access verification

- `agent-admin` can write `upload_files`: PASS
- `agent-dev` can write `upload_files`: PASS
- `agent-test` can write `upload_files`: PASS
- `agent-admin` can write `api_keys`: PASS
- `agent-dev` can write `api_keys`: PASS
- `agent-test` cannot read or write `api_keys`: PASS
- `agent-admin` can write `/var/log/agent-app`: PASS
- `agent-dev` can write `/var/log/agent-app`: PASS
- `agent-test` cannot read or write `/var/log/agent-app`: PASS

Final runtime marker:

- `[PASS] B4-1 FILESYSTEM + ACL`

## Regression guard

After the filesystem/ACL mutation:

- effective SSH port remained `20022`
- effective `PermitRootLogin` remained `no`
- UFW remained `active`
- inbound ALLOW rules remained limited to `20022/tcp` and `15034/tcp` for IPv4/IPv6

## State boundary

This checkpoint proves the shared directory tree, ACL policy, and effective role access only.

Not yet proven:

- Secret file preparation
- Agent binary installation
- `env.sh`
- Agent Boot Sequence / TCP 15034 runtime
- monitor/cron/logrotate
- final verification

B4-1 Mission CLEAR: NO

## Evidence hygiene

No password, private key, key passphrase, mission Secret value, or other sensitive value is recorded here.
