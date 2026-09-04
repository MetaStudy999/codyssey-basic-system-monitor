# B4-1 MAC-V — UFW Final Policy Precheck PASS

## Scope

This evidence records the read-only UFW precheck immediately before applying the final B4-1 firewall policy on MAC-V / OrbStack Ubuntu 24.04.

## Runtime result

- UFW current status: `inactive`
- Numbered UFW rules: none while inactive
- Configured user rules (`ufw show added`): none
- `/etc/default/ufw` baseline:
  - `IPV6=yes`
  - `DEFAULT_INPUT_POLICY="DROP"`
  - `DEFAULT_OUTPUT_POLICY="ACCEPT"`
  - `DEFAULT_FORWARD_POLICY="DROP"`
- Actual SSH listener:
  - TCP 20022 IPv4: LISTEN
  - TCP 20022 IPv6: LISTEN
  - TCP 22: absent
- Effective SSH policy:
  - `port 20022`
  - `permitrootlogin no`

## Interpretation

The firewall baseline is clean: there are no legacy or unrelated user-added ALLOW rules to remove before enabling UFW. The SSH path is already on the final TCP 20022-only listener and root SSH login is disabled.

The next gate is to add the two required inbound rules before enabling UFW:

- `20022/tcp`
- `15034/tcp`

Then enforce default deny incoming / allow outgoing, enable UFW, verify the complete policy, and prove a fresh macOS Host → Ubuntu TCP 20022 login still succeeds after the firewall is active.

## Safety boundary

This checkpoint is read-only. It does **not** claim that UFW is active yet.

## Evidence hygiene

- Private key/passphrase/password: not recorded
- Mission secret: not recorded
- Client IP / ephemeral source port: not recorded

## State

- UFW clean precheck: PASS
- TCP20022-only SSH listener: PASS
- Effective `PermitRootLogin no`: PASS
- Final UFW policy: NOT RUN
- Post-UFW fresh TCP20022 login: NOT RUN
- B4-1 Mission CLEAR: NO
