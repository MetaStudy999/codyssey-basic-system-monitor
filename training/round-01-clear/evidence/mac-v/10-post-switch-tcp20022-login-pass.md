# B4-1 MAC-V — Post-switch TCP20022 Public-key Login PASS

## Scope

This evidence records a fresh macOS Host → OrbStack Ubuntu 24.04 OpenSSH login after the final `ssh.socket` restart and TCP22 removal.

## Runtime result

- macOS Host used the dedicated B4-1 ED25519 identity.
- Fresh SSH session to Ubuntu TCP 20022 succeeded after the final listener switch.
- Remote user: `metastudy9997479`
- Remote hostname: `codyssey`
- `SSH_CONNECTION` server destination port: `20022`
- PASS marker: `[PASS] POST-SWITCH TCP20022 LOGIN`

## Proven state

- Final listener policy: TCP 20022 only — previously proven.
- Effective SSH policy: `Port 20022`, `PermitRootLogin no` — previously proven.
- Fresh post-switch non-root ED25519 public-key authentication: PASS.
- TCP22 is not required for the working mission SSH path.

## Evidence hygiene

The public repository evidence intentionally does not record:

- private key material
- key passphrase
- passwords
- client IP address
- ephemeral client source port
- mission secret or `t_secret.key` value

## State boundary

This checkpoint completes the SSH transition/authentication gate. It does **not** yet prove the final firewall policy.

Remaining next gate:

- UFW active
- default deny incoming
- inbound ALLOW only for `20022/tcp` and `15034/tcp`
- fresh TCP20022 SSH login after UFW enable

## State

- Final TCP20022 listener: PASS
- `PermitRootLogin no`: PASS
- Post-switch TCP20022 public-key login: PASS
- UFW final policy: NOT RUN
- B4-1 Mission CLEAR: NO
