# B4-1 MAC-V — Final SSH Config Precheck PASS

## Purpose

Record the read-only precheck immediately before writing the final B4-1 OpenSSH drop-in.

## Runtime result

Context: MAC-V / OrbStack Ubuntu 24.04

Observed state:

- `/etc/ssh/sshd_config` includes `/etc/ssh/sshd_config.d/*.conf`.
- No active `Port` or `PermitRootLogin` directives were found in the scanned main/drop-in files.
- Effective OpenSSH configuration before the final drop-in:
  - `port 22`
  - `permitrootlogin without-password`
- Temporary safe socket bridge is still present.
- Runtime listeners remain available on both TCP 22 and TCP 20022 for IPv4 and IPv6.
- UFW remains inactive.

## Interpretation

This establishes a clean baseline for the final mission-owned drop-in:

```text
/etc/ssh/sshd_config.d/99-codyssey-b4-1.conf
```

The next write checkpoint may set only the mission-required final directives:

```text
Port 20022
PermitRootLogin no
```

The socket must not be restarted in the same checkpoint. First validate `sshd -t` and the effective `sshd -T` result while the already-proven TCP 22/TCP 20022 bridge remains available.

## State boundary

PASS at this checkpoint:

- Direct TCP 22 public-key login
- Safe TCP 22 + TCP 20022 socket bridge
- Direct TCP 20022 public-key login
- Final SSH configuration precheck

Not yet PASS:

- final sshd drop-in syntax/effective configuration
- final `ssh.socket` cutover to TCP 20022 only
- post-cutover direct TCP 20022 login
- TCP 22 removal
- final UFW policy
- B4-1 Mission CLEAR
