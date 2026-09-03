# B4-1 R01 — MAC-V SSH Pre-change Authentication Checkpoint

## 목적

`ssh.socket`의 listener를 22 → 20022로 바꾸기 전에 macOS Host에서 현재 Ubuntu OpenSSH Server로 정상 인증 가능한 경로가 있는지 확인합니다.

이 checkpoint는 `ssh orb` 같은 OrbStack 관리 접속과 Mission OpenSSH 접속을 분리합니다.

## PASS 기준

현재 TCP 22 baseline에서 별도 macOS Terminal로 다음을 실제 확인합니다.

```text
macOS Host
→ Ubuntu VM reachable address
→ TCP 22
→ OpenSSH authentication
→ non-root Ubuntu user session
```

새 세션 안에서 `whoami`와 `SSH_CONNECTION`이 확인되어야 합니다.

## 상태

`NOT RUN`

이 확인이 실패하면 아직 `Port 20022` 설정을 적용하지 않습니다. Root 로그인 허용이나 인증 약화로 우회하지 않고, 비-root 사용자의 정상 password/public-key 인증 경로를 먼저 복구합니다.
