# B4-1 MAC-V — Post-UFW Fresh TCP20022 Login PASS

## Scope

This evidence records a fresh macOS Host → Ubuntu TCP 20022 SSH login after the final UFW policy was enabled.

## Runtime result

- Runtime marker: `[PASS] POST-UFW FRESH TCP20022 LOGIN`
- Authentication path: macOS Host → Ubuntu TCP 20022
- Authentication method: ED25519 public key
- Remote user: `metastudy9997479`
- Hostname: `codyssey`
- `SSH_CONNECTION` confirmed server destination port `20022`
- The login occurred after UFW was active with inbound ALLOW limited to TCP 20022 and TCP 15034.

## What this proves

The final SSH and firewall segment is now closed:

- effective SSH port: TCP 20022
- `PermitRootLogin no`
- TCP 22 removed
- UFW active
- default deny incoming
- inbound ALLOW only TCP 20022 and TCP 15034
- a brand-new TCP 20022 public-key SSH session succeeds after UFW activation

## Evidence hygiene

- Private key: not recorded
- Key passphrase/password: not recorded
- Client IP and ephemeral source port: not recorded
- Mission secret: not recorded

## State

- SSH final configuration: PASS
- UFW final policy: PASS
- Post-UFW fresh TCP20022 login: PASS
- SSH + UFW runtime segment: PASS
- Users / groups / ACL: NOT RUN
- Agent runtime / TCP15034: NOT RUN
- B4-1 Mission CLEAR: NO
