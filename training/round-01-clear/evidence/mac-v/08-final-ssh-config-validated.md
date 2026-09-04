# B4-1 MAC-V — Final SSH Configuration Validation PASS

## Scope

This evidence records the configuration-validation checkpoint only. The Ubuntu 24.04 `ssh.socket` was **not restarted** in this checkpoint.

## Runtime result

Mission-owned drop-in:

```text
/etc/ssh/sshd_config.d/99-codyssey-b4-1.conf
owner=root group=root mode=0644
```

Configured policy:

```text
Port 20022
PermitRootLogin no
```

Validation:

```text
[PASS] sshd -t
port 20022
permitrootlogin no
[PASS] effective Port 20022
[PASS] effective PermitRootLogin no
```

Runtime listeners were intentionally unchanged at this checkpoint:

```text
TCP 22     LISTEN
TCP 20022  LISTEN
```

The temporary safe socket bridge remained installed:

```ini
[Socket]
ListenStream=0.0.0.0:20022
ListenStream=[::]:20022
```

UFW remained inactive.

## PASS boundary

- final SSH drop-in written: PASS
- `sshd -t`: PASS
- effective `Port 20022`: PASS
- effective `PermitRootLogin no`: PASS
- socket restart: NOT RUN
- final `20022 only` listener state: NOT RUN
- post-restart direct TCP 20022 login: NOT RUN
- UFW final policy: NOT RUN
- B4-1 Mission CLEAR: NO

## Next gate

Safely remove the temporary transition bridge, reload systemd generators, restart `ssh.socket`, verify that TCP 20022 is listening and TCP 22 is no longer listening, then validate a fresh macOS Host → Ubuntu TCP 20022 public-key SSH session before proceeding to UFW.