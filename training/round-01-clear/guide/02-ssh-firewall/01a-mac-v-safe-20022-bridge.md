# B4-1 MAC-V — Ubuntu 24.04 안전한 TCP 20022 전환 브리지

> Current Mission ID: **B4-1**  
> Runtime Context: **MAC-V / OrbStack Ubuntu 24.04 / `ssh.socket` active**  
> 이 절차는 현재 TCP 22 직접 공개키 로그인이 실제로 PASS한 경우에만 사용합니다.

## 왜 브리지를 사용하는가

Ubuntu 24.04는 OpenSSH를 `ssh.socket` 기반으로 활성화할 수 있습니다. 이 환경에서 `sshd_config`의 Port 변경은 `systemctl daemon-reload` 이후 `ssh.socket`에 반영됩니다.

또한 Ubuntu Noble의 `sshd-socket-generator`에는 여러 `Port` 지시자를 동시에 사용할 때 의도대로 다중 listener를 생성하지 못했던 알려진 문제가 있으므로, 전환 중 `Port 22` + `Port 20022`를 `sshd_config`에 동시에 넣어 안전성을 확보하는 방법은 사용하지 않습니다.

대신 systemd socket의 `ListenStream=`이 여러 번 지정될 수 있다는 특성을 이용하여 **임시 브리지 단계에서만** TCP 22를 유지한 채 TCP 20022 listener를 추가합니다.

## 전환 상태 머신

```text
Known-good TCP22 public-key login
→ temporary ssh.socket bridge adds TCP20022 while preserving TCP22
→ verify both listeners
→ direct TCP20022 public-key login
→ write B4-1 sshd drop-in: Port 20022 + PermitRootLogin no
→ sshd -t / sshd -T
→ remove temporary bridge
→ daemon-reload + restart ssh.socket
→ final listener TCP20022
→ direct TCP20022 login again
→ only then proceed to UFW final policy
```

## 브리지 파일

임시 파일 경로:

```text
/etc/systemd/system/ssh.socket.d/90-codyssey-b4-1-transition.conf
```

브리지 내용은 기존 listener 목록을 초기화하지 않고 다음 두 주소를 **추가**합니다.

```ini
[Socket]
ListenStream=0.0.0.0:20022
ListenStream=[::]:20022
```

`ListenStream=` 빈 값을 사용하지 않는 이유는 현재 TCP 22 listener를 유지하기 위해서입니다.

## 브리지 적용 Gate

브리지 적용 전:

- direct TCP22 public-key login PASS
- `ssh.socket` active
- TCP 22 LISTEN
- UFW inactive 또는 TCP20022 사전 허용 완료

브리지 적용 후 반드시 확인:

```text
TCP 22    LISTEN
TCP 20022 LISTEN
```

둘 중 하나라도 예상과 다르면 SSH 설정 파일을 변경하지 않고 브리지 파일을 제거하여 baseline으로 복구합니다.

## 브리지 복구

```bash
sudo rm -f /etc/systemd/system/ssh.socket.d/90-codyssey-b4-1-transition.conf
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket
sudo ss -lntp | grep -E ':(22|20022)\b' || true
```

## 중요 경계

브리지에서 TCP20022가 LISTEN하는 것만으로 공식 B4-1 `effective port 20022` 요구사항을 PASS 처리하지 않습니다. 최종 PASS에는 다음이 모두 필요합니다.

```text
sshd -T → port 20022
sshd -T → permitrootlogin no
TCP 20022 LISTEN
macOS Host → direct TCP20022 public-key login PASS
```

## 참고 근거

- Ubuntu 24.04 OpenSSH socket activation: `sshd_config` 변경 후 `systemctl daemon-reload` + `systemctl restart ssh.socket` 필요.
- systemd `ListenStream=`은 여러 번 지정 가능하며, 빈 `ListenStream=`은 이전 목록을 초기화함.
- Ubuntu OpenSSH Noble에는 복수 `Port` 설정을 socket generator가 잘못 처리한 이력이 있음.
