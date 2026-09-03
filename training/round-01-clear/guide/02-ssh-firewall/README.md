# B4-1 모듈 02 — 보안 원격 접속(Secure Shell, SSH)과 방화벽(Firewall)

> 현재 Mission ID: **B4-1** / 이전 ID: **B1-1**  
> 범위: **STEP 03~04**  
> [← 모듈 01](../01-preflight-baseline/README.md) · [전체 입문자 가이드](../../BEGINNER-GUIDE.md) · [다음: 모듈 03 →](../03-users-groups-acl/README.md)

## 이 모듈의 목적

보안 원격 접속(Secure Shell, SSH)과 방화벽(Firewall)을 하나의 네트워크 접근 제어 흐름으로 학습합니다. SSH 포트와 Root 로그인 정책을 먼저 안전하게 설정한 뒤, 방화벽에서 필요한 인바운드(Inbound) 포트만 허용합니다.

Ubuntu 24.04에서는 OpenSSH가 `ssh.socket` 기반 socket activation으로 동작할 수 있으므로, **SSH 설정을 쓰기 전에 반드시 socket activation 상태부터 확인**합니다. `ssh.service`가 inactive인데 TCP 22가 LISTEN이면 특히 이 확인을 생략하지 않습니다.

## 📑 모듈 목차(Module Table of Contents, Module TOC)

### 0. Ubuntu 24.04 SSH 동작 방식 확인
- [안전 가드 — `ssh.socket` / `ssh.service` / listener 판정](00-ubuntu24-socket-activation.md)

### 1. SSH 서버 설정과 실제 새 연결 검증
- [STEP 03 — SSH 20022 / Root 원격 로그인 차단](01-ssh.md)

### 2. 방화벽 정책과 허용 포트 정리
- [STEP 04 — UFW 방화벽 정책 구성](02-firewall.md)

## 완료 조건

- [ ] Ubuntu 24.04 `ssh.socket` 사용 여부 확인
- [ ] STEP 03 완료
- [ ] STEP 04 완료
- [ ] SSH 설정과 실제 리슨(Listen)·새 세션 검증의 차이를 이해했다.
- [ ] 방화벽 허용(ALLOW)과 실제 서비스 리슨(Listen)의 차이를 이해했다.

## 이동

[← 모듈 01](../01-preflight-baseline/README.md) · [전체 입문자 가이드](../../BEGINNER-GUIDE.md) · [다음: 모듈 03 →](../03-users-groups-acl/README.md)
