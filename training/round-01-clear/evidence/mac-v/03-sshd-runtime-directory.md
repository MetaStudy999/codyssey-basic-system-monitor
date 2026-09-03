# B4-1 R01 — MAC-V SSHD Runtime Directory Evidence

## 실제 Runtime 결과

Runtime Context: `MAC-V`

```text
ssh.service RuntimeDirectory=sshd
ssh.service RuntimeDirectoryMode=0755

Before:
/run/sshd = not present

After minimal preparation:
path=/run/sshd owner=root group=root mode=755

sshd -t = PASS

Effective SSH baseline:
port 22
permitrootlogin without-password

Listener baseline:
0.0.0.0:22 = systemd PID 1
[::]:22      = systemd PID 1

UFW:
Status: inactive
```

## 판정

- `/run/sshd` Runtime Directory: **PASS**
- owner/group/mode: **root:root / 0755 PASS**
- `sshd -t`: **PASS**
- effective SSH configuration baseline: **captured**
- current SSH port: **22 (baseline only)**
- current `PermitRootLogin`: **without-password** → STEP 03에서 `no`로 변경 필요
- Ubuntu 24.04 socket activation: **CONFIRMED**
- UFW baseline: **inactive**

## 다음 Gate

TCP 20022 설정을 적용하기 전에 별도의 macOS Terminal에서 현재 TCP 22 OpenSSH 경로로 **비-root 사용자 실제 인증**이 가능한지 확인합니다.

이 Gate가 실패하면 `Port 20022`를 적용하지 않고 정상 password/public-key 인증 경로부터 복구합니다.

## 상태 경계

아직 다음 항목은 PASS가 아닙니다.

```text
SSH backup/checkpoint
Port 20022 effective
PermitRootLogin no effective
TCP 20022 LISTEN
macOS Host → Ubuntu TCP 20022 actual SSH session
UFW final policy
B4-1 Mission CLEAR
```

Secret, password, SSH private key, token은 기록하지 않았습니다.
