# B4-1 MAC-V Evidence — TCP 20022 Safe Socket Bridge PASS

> Current Mission ID: **B4-1**  
> Runtime Context: **MAC-V / OrbStack Ubuntu 24.04**

## 목적

최종 SSH 포트 전환 전에 기존 TCP 22 경로를 유지한 상태에서 TCP 20022 listener를 임시 systemd `ssh.socket` drop-in으로 추가하고, 실제 listener 상태를 검증한다.

## 실제 Runtime 결과

실행 시점 baseline:

```text
ssh.socket = active
TCP 22     = LISTEN
UFW        = inactive
```

임시 bridge 파일:

```text
/etc/systemd/system/ssh.socket.d/90-codyssey-b4-1-transition.conf
```

적용 후 `ssh.socket` 상태에서 다음 listener가 동시에 확인되었다.

```text
0.0.0.0:22      LISTEN
[::]:22         LISTEN
0.0.0.0:20022   LISTEN
[::]:20022      LISTEN
```

실제 출력의 PASS marker:

```text
[PASS] TCP22 preserved
[PASS] TCP20022 bridge listening
[PASS] SAFE SOCKET BRIDGE
```

## 판정

- TCP 22 기존 경로 유지: **PASS**
- TCP 20022 임시 listener 생성: **PASS**
- `ssh.socket` active: **PASS**
- systemd drop-in 적용: **PASS**
- UFW baseline inactive 유지: **PASS**

## 아직 PASS가 아닌 항목

이 Evidence는 listener bridge까지만 증명한다.

```text
Direct TCP 20022 public-key login  = NOT RUN
Effective sshd Port 20022          = NOT RUN
PermitRootLogin no                 = NOT RUN
Final removal of TCP 22            = NOT RUN
UFW final policy                   = NOT RUN
B4-1 Mission CLEAR                 = NO
```

## 다음 Gate

macOS Host에서 기존 B4-1 전용 ED25519 private key를 사용해 다음 경로를 실제 검증한다.

```text
macOS Host
→ 192.168.139.229:20022
→ OpenSSH
→ metastudy9997479 public-key authentication
```

이 실제 세션이 성공하기 전에는 기존 TCP 22 listener를 제거하지 않는다.
