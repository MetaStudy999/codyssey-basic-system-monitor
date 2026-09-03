# B4-1 MAC-V — SSH Activation Baseline Evidence

- Runtime Context: `MAC-V`
- Environment: school macOS → OrbStack → Ubuntu 24.04
- Mission: `B4-1 — 시스템 관제`
- Evidence scope: SSH socket/service activation baseline only

## Actual observed result

```text
ssh.socket   = active
ssh.socket   = enabled
ssh.service  = inactive
ssh.service  = disabled

ssh.socket Listen:
0.0.0.0:22
[::]:22

actual TCP 22 listener owner:
systemd (PID 1)

UFW:
Status: inactive
```

`ssh.socket` is therefore the active listener path for the current Ubuntu 24.04 MAC-V runtime. `ssh.service` being inactive is not treated as a failure by itself because the listener is owned by systemd socket activation.

## Effective sshd configuration check

The first manual `sshd -T` check did **not** return effective configuration. It stopped with:

```text
Missing privilege separation directory: /run/sshd
```

This is recorded as a runtime prerequisite issue to resolve before writing any SSH configuration or changing the listener port.

## Safety boundary

At this checkpoint no SSH/UFW configuration was changed:

- no `sshd_config`/drop-in write
- no `ssh.socket` restart
- no `ssh.service` reload/restart
- no `ufw enable`
- no firewall allow/delete rule
- no removal of TCP 22
- no TCP 20022 transition yet

## Current judgment

```text
Ubuntu 24.04 socket activation path     PASS / CONFIRMED
TCP 22 current listener                 PASS / BASELINE CAPTURED
UFW baseline                            PASS / INACTIVE CAPTURED
effective sshd config                   BLOCKED by missing /run/sshd
SSH 20022                               NOT RUN
Mission CLEAR                           NO
```

The next action is a minimal `/run/sshd` runtime-directory repair and another `sshd -t` / `sshd -T` read-only validation. Only after that validation succeeds may STEP 03 write the B4-1 SSH drop-in.
