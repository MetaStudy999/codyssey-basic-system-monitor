# B4-1 MAC-V — Pre-UFW Safety SSH Session PASS

## Scope

This evidence records the live macOS Host → Ubuntu TCP 20022 SSH safety session established immediately before applying the final UFW policy.

## Runtime result

- Connection path: macOS Host → Ubuntu
- Destination port: TCP 20022
- Authentication: ED25519 public key
- Remote user: `metastudy9997479`
- Hostname: `codyssey`
- Runtime marker: `[PASS] PRE-UFW SAFETY SSH SESSION`
- `SSH_CONNECTION` confirmed server destination port `20022`

## Why this gate exists

The final UFW step can affect remote access. A known-good TCP 20022 SSH session is therefore kept open before firewall activation so the runtime has a recovery/control path while the required rules are applied and verified.

## Evidence hygiene

- Private key: not recorded
- Key passphrase/password: not recorded
- Client IP and ephemeral source port: not recorded
- Mission secret: not recorded

## State

- Final SSH listener: PASS (`TCP 20022 only`)
- `PermitRootLogin no`: PASS
- Post-switch fresh TCP20022 login: PASS
- Pre-UFW safety SSH session: PASS / kept open for firewall change
- UFW final policy: NOT RUN
- B4-1 Mission CLEAR: NO
