# B4-1 MAC-V — Final SSH Socket Switch PASS

## Scope

This evidence records the final Ubuntu 24.04 socket-activated OpenSSH runtime switch to TCP 20022 only.

## Runtime result

- Effective `sshd` configuration before the switch:
  - `port 20022`
  - `permitrootlogin no`
- Planned `ssh.socket` listeners:
  - IPv4 TCP 20022
  - IPv6 TCP 20022
- `systemctl restart ssh.socket`: completed
- `ssh.socket`: `active`
- Actual listeners after restart:
  - IPv4 TCP 20022: LISTEN
  - IPv6 TCP 20022: LISTEN
  - TCP 22: absent
- Runtime PASS markers:
  - `[PASS] TCP20022 listening`
  - `[PASS] TCP22 removed`
  - `[PASS] FINAL SSH SOCKET = TCP20022 ONLY`
- UFW remained inactive during this checkpoint.

## Safety boundary

This checkpoint proves the listener transition only. It does **not** yet prove that a fresh macOS Host session can authenticate after the final socket restart.

The next gate is a new macOS Host → Ubuntu TCP 20022 ED25519 public-key login after this final restart.

## Evidence hygiene

- Private key: not recorded
- Passphrase/password: not recorded
- Client IP and ephemeral source port: not recorded
- Mission secret: not recorded

## State

- Final SSH listener policy: PASS (`20022 only`)
- Effective `PermitRootLogin no`: PASS
- Post-switch direct TCP20022 login: NOT RUN
- UFW final policy: NOT RUN
- B4-1 Mission CLEAR: NO
