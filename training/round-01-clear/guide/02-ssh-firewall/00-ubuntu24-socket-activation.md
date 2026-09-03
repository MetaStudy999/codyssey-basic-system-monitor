# B4-1 모듈 02 — Ubuntu 24.04 SSH Socket Activation 확인

> 현재 Mission ID: **B4-1** / 이전 ID: **B1-1**  
> 이 문서는 STEP 03에서 SSH 설정을 쓰기 전에 Ubuntu 24.04의 `ssh.socket` 사용 여부를 먼저 확인하는 안전 가드입니다.

## 왜 먼저 확인하는가

Ubuntu 24.04에서는 OpenSSH가 `ssh.socket` 기반 socket activation으로 동작할 수 있습니다. 이 경우 `ssh.service`가 inactive처럼 보여도 systemd가 TCP 22를 LISTEN할 수 있습니다.

따라서 다음 상태는 서로 모순이 아닐 수 있습니다.

```text
ssh.service = inactive
TCP 22       = LISTEN
ssh.socket   = active
```

이 환경에서 `sshd_config`의 `Port`를 변경한 뒤 `systemctl reload ssh`만 실행하면 실제 listener가 계속 22에 남을 수 있습니다. Socket activation을 사용하는 경우 설정 검증 후 `systemctl daemon-reload`와 `systemctl restart ssh.socket`을 포함해 실제 listener를 갱신해야 합니다.

## 1. 변경 전 읽기 전용 확인

아래 명령은 SSH 설정을 변경하지 않습니다.

```bash
sudo systemctl is-active ssh.socket || true
sudo systemctl is-enabled ssh.socket || true
sudo systemctl is-active ssh.service || true

sudo systemctl status ssh.socket ssh.service --no-pager -l || true

echo '===== ssh.socket unit ====='
sudo systemctl cat ssh.socket || true

echo '===== effective sshd config ====='
sudo sshd -T | grep -E '^(port|permitrootlogin) '

echo '===== listeners ====='
sudo ss -lntp | grep -E ':(22|20022)\b' || true
```

## 2. 판정

### A. `ssh.socket` active

```text
ssh.socket = active
TCP 22 listener = systemd 또는 socket activation 경로
```

→ STEP 03은 **socket-activation-aware 경로**로 수행합니다.

Port 변경 후 적용 순서:

```text
sshd_config/drop-in 백업
→ B4-1 drop-in 작성
→ sshd -t
→ sshd -T
→ systemctl daemon-reload
→ systemctl restart ssh.socket
→ 20022 LISTEN 확인
→ 별도 macOS Terminal에서 실제 새 SSH 세션 확인
```

새 20022 세션이 성공하기 전에는 기존 22 경로를 제거하지 않습니다.

### B. `ssh.socket` inactive / 일반 ssh.service 방식

→ 기존 service 기반 경로를 사용할 수 있지만, `sshd -t`와 `sshd -T` 검증 후 실제 listener를 반드시 확인합니다.

## 3. 아직 하지 않는 것

이 확인 단계에서는 다음을 실행하지 않습니다.

```text
ufw enable
ufw allow/delete
sshd_config 쓰기
ssh.socket restart
ssh.service reload/restart
22/tcp 제거
20022/tcp 최종 전환
```

## 완료 기준

- [ ] `ssh.socket` active/inactive 판정
- [ ] `ssh.service` 상태 확인
- [ ] TCP 22 listener owner/process 확인
- [ ] 현재 effective `port` / `permitrootlogin` 확인
- [ ] 이후 적용 경로를 socket-activation-aware 또는 service 방식으로 결정

이 단계만으로 SSH 20022 PASS 또는 B4-1 CLEAR를 기록하지 않습니다.
