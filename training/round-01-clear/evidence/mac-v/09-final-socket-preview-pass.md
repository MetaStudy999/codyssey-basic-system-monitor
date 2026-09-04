# B4-1 MAC-V — Final SSH Socket Preview PASS

## 목적

최종 SSH 정책(`Port 20022`, `PermitRootLogin no`)이 반영된 상태에서 임시 transition bridge를 제거하고 `systemctl daemon-reload` 후, `ssh.socket`을 실제로 재시작하기 전에 systemd가 다음 activation에서 TCP 20022만 리슨하도록 계획하는지 read-only로 검증한다.

## Runtime 결과

- effective sshd configuration:
  - `port 20022`
  - `permitrootlogin no`
- temporary transition bridge:
  - 제거 완료
- `systemctl daemon-reload`:
  - 완료
- generated socket override:
  - `/run/systemd/generator/ssh.socket.d/addresses.conf`
  - base `ListenStream`을 reset
  - IPv4 TCP 20022 추가
  - IPv6 TCP 20022 추가
- `systemctl show ssh.socket -p Listen --value`:
  - `0.0.0.0:20022 (Stream)`
  - `[::]:20022 (Stream)`
- `ssh.socket` state:
  - active

## 중요한 Runtime 경계

`daemon-reload` 직후 실제 프로세스는 아직 restart되지 않았으므로 기존 sshd process가 TCP 22와 TCP 20022 file descriptor를 계속 보유할 수 있다. 실제 listener 출력에서 TCP 22가 남아 있는 것은 이 체크포인트에서는 예상 가능한 상태다.

핵심 판정은 **systemd의 planned Listen addresses가 TCP 20022 only**라는 점이다.

## PASS 판정

- [x] 최종 sshd effective port = 20022
- [x] final PermitRootLogin = no
- [x] temporary bridge 제거
- [x] generated `ssh.socket` configuration = TCP 20022 only
- [x] socket restart 전 preview 완료

**Result: PASS — final socket restart gate 진입 가능**

## 아직 완료하지 않은 항목

- [ ] final `ssh.socket` restart
- [ ] TCP 22 listener 제거 확인
- [ ] TCP 20022-only listener 확인
- [ ] restart 후 macOS Host에서 direct TCP 20022 public-key login 재검증
- [ ] UFW final policy
- [ ] B4-1 Mission CLEAR

## Security / Evidence hygiene

- private key 미기록
- passphrase/password/secret 미기록
- client source IP 및 ephemeral port 미기록
- 공개 Evidence에는 mission 판정에 필요한 port/policy 상태만 기록
