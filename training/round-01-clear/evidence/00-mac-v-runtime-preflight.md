# B4-1 R01 — MAC-V Runtime Preflight Evidence

> Current Mission ID: **B4-1**  
> Runtime Profile: **MAC-V — macOS → OrbStack → Ubuntu 24.04**  
> Evidence scope: **read-only runtime preflight only**

## Result

```text
PASS=30
WARN=1
FAIL=0
[PASS] B4-1 Runtime Preflight
```

## Confirmed

- Linux runtime
- Ubuntu 24.04
- `x86_64` architecture
- PID 1 = `systemd`
- MAC-V OrbStack marker detected
- required commands available, including `getfacl`, `ufw`, and OpenSSH server binary
- Canonical Repository = `MetaStudy999/codyssey-basic-system-monitor`
- current Mission metadata = B4-1
- branch = `main`
- Git working tree clean
- provided `agent-app.zip` exists
- `monitor.sh` Bash syntax PASS
- current TCP 22 listener observed
- UFW currently inactive
- mission users/groups and `/opt/agent-app`, `/var/log/agent-app` not yet created

## Warning retained

```text
ssh.service currently inactive or unavailable — SSH STEP에서 실제 service 상태를 다시 확인한다.
```

TCP 22 was observed listening, so the service/process state must be reconciled in the next SSH baseline step before any configuration is written.

## State boundary

This evidence proves only the **B4-1 read-only Runtime Preflight**.

It does **not** prove:

- SSH 20022 configuration or real new-session success
- UFW final policy
- users/groups/ACL completion
- Agent Boot 5/5 or `Agent READY`
- TCP 15034 final listener
- monitor/log rotation/cron runtime
- integrated verification 0 FAIL
- B4-1 Mission CLEAR

No Secret value is recorded in this file.
