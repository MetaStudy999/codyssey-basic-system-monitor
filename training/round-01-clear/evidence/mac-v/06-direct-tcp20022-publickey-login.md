# B4-1 MAC-V Evidence — Direct TCP 20022 Public-Key Login PASS

> Current Mission ID: **B4-1** / Previous Mission ID: **B1-1**

## Purpose

Record the first successful **macOS Host → OrbStack Ubuntu 24.04 OpenSSH TCP 20022** login using the B4-1 dedicated ED25519 public-key authentication path.

This evidence is intentionally limited to the direct TCP 20022 authentication gate. It does **not** claim final SSH configuration, UFW completion, or Mission CLEAR.

## Runtime result

Verified from a separate macOS Terminal:

```text
[PASS] DIRECT TCP20022 PUBLICKEY LOGIN
remote user = metastudy9997479
hostname    = codyssey
server destination port in SSH_CONNECTION = 20022
```

The RFC1918 client/server addresses and ephemeral client port are intentionally omitted from public evidence.

## Authentication path

- macOS Host private key: B4-1 dedicated ED25519 key; value never committed or pasted into evidence
- Ubuntu account: `metastudy9997479`
- Ubuntu `authorized_keys`: ED25519 public key registered
- `~/.ssh`: owner user, mode `700`
- `~/.ssh/authorized_keys`: owner user, mode `600`
- Password for the Ubuntu account remains locked; the account was **not** unlocked for this test
- Authentication used public key only

## Network path proven

```text
macOS Host
  → OrbStack Ubuntu IPv4 address
  → TCP 20022
  → Ubuntu OpenSSH
  → ED25519 public-key authentication
  → metastudy9997479
  → hostname codyssey
```

`SSH_CONNECTION` proved that the server-side destination port of the actual session was `20022`.

## Current bridge state at time of login

The previously verified temporary `ssh.socket` transition bridge remained active:

```text
TCP 22     = LISTEN
TCP 20022  = LISTEN
UFW        = inactive
```

Therefore the original TCP 22 access path was still preserved during this first TCP 20022 authentication test.

## PASS boundary

The following are now proven:

- [x] TCP 20022 listener exists
- [x] macOS Host can reach TCP 20022
- [x] B4-1 ED25519 authentication succeeds on TCP 20022
- [x] Remote non-root user is `metastudy9997479`
- [x] Remote hostname is `codyssey`
- [x] Actual session destination port is `20022`

The following are **not yet PASS**:

- [ ] final `sshd_config.d` contains `Port 20022`
- [ ] effective `sshd -T` reports `port 20022`
- [ ] effective `sshd -T` reports `permitrootlogin no`
- [ ] temporary TCP 22 bridge removed
- [ ] final socket state verified after `daemon-reload` / `ssh.socket` restart
- [ ] direct TCP 20022 login re-verified after final switch
- [ ] UFW final policy
- [ ] B4-1 Mission CLEAR

## Secret handling

No private key, passphrase, password, token, or mission secret is stored in this evidence.
