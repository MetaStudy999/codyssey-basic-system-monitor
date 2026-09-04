# B4-1 MAC-V — UFW Final Policy PASS

## Scope

This evidence records the actual MAC-V runtime application of the B4-1 final UFW policy after the SSH service had already been migrated to TCP 20022 only and a live safety SSH session had been established.

## Runtime result

- UFW checkpoint created before mutation.
- Required inbound rules were added before firewall enable:
  - `20022/tcp`
  - `15034/tcp`
- Default policies:
  - incoming: `deny`
  - outgoing: `allow`
  - routed: `deny`
- UFW was enabled successfully and enabled on system startup.
- Final UFW status: `active`.
- IPv4 inbound ALLOW rules:
  - `20022/tcp`
  - `15034/tcp`
- IPv6 inbound ALLOW rules:
  - `20022/tcp (v6)`
  - `15034/tcp (v6)`
- No extra inbound ALLOW rules were present.
- Final gate markers:
  - `[PASS] UFW active`
  - `[PASS] default deny incoming`
  - `[PASS] 20022/tcp ALLOW IN`
  - `[PASS] 15034/tcp ALLOW IN`
  - `[PASS] no extra inbound ALLOW rules`
  - `[PASS] B4-1 UFW FINAL POLICY`

## SSH safety state during firewall application

- Effective `sshd` port: `20022`
- Effective `PermitRootLogin`: `no`
- Actual SSH listener after UFW enable: TCP 20022 on IPv4 and IPv6
- TCP 22 remained absent
- A separate pre-UFW TCP 20022 SSH safety session was intentionally kept open during this change

## State boundary

This checkpoint proves the final firewall policy itself. A new macOS Host -> Ubuntu TCP 20022 login **after UFW activation** is still required before the firewall/SSH segment is considered fully closed.

TCP 15034 is allowed by UFW but is not required to be LISTENing until the Agent runtime step.

## Evidence hygiene

- Private key: not recorded
- Passphrase/password: not recorded
- Client IP / ephemeral source port: not recorded
- Mission secret: not recorded

## State

- SSH final configuration: PASS
- TCP 20022-only listener: PASS
- UFW final policy: PASS
- Post-UFW fresh TCP20022 login: NOT RUN
- Agent runtime / TCP15034: NOT RUN
- B4-1 Mission CLEAR: NO
