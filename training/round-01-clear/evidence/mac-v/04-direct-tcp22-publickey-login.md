# B4-1 MAC-V — Direct TCP 22 Public-Key Login Evidence

> Current Mission ID: **B4-1**  
> Runtime Context: **MAC-V / macOS Host → OrbStack Ubuntu 24.04**  
> Evidence boundary: no private key, passphrase, full public key, password, token, or secret value is stored here.

## Proven result

A dedicated ED25519 key pair was prepared on the macOS Host. Only the public key was registered in the Ubuntu user's `authorized_keys`.

Ubuntu-side permissions were verified as:

```text
~/.ssh                  owner=metastudy9997479 mode=700
~/.ssh/authorized_keys  owner=metastudy9997479 mode=600
registered key type     ssh-ed25519
```

The macOS Host then opened a direct SSH connection to the Ubuntu OpenSSH Server using the dedicated private key and explicit destination `192.168.139.229:22`.

Sanitized runtime result:

```text
[PASS] DIRECT TCP22 PUBLICKEY LOGIN
user     = metastudy9997479
hostname = codyssey
server destination port in SSH_CONNECTION = 22
```

## Interpretation

This proves all of the following before changing the SSH port:

- macOS Host can reach the Ubuntu OpenSSH Server directly over TCP 22.
- The intended non-root Ubuntu user can authenticate with public-key authentication.
- The login is not merely the OrbStack convenience alias path.
- A known-good authentication path exists before the B4-1 port transition.

## State boundary

This evidence does **not** prove the following yet:

- TCP 20022 listener
- direct TCP 20022 login
- `PermitRootLogin no`
- final UFW policy
- B4-1 Mission CLEAR

Next safe action: preserve the known-good TCP 22 path, add a temporary `ssh.socket` listener bridge for TCP 20022, verify direct TCP 20022 public-key login, and only then finalize the SSH configuration.
