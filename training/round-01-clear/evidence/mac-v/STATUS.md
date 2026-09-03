# B4-1 R01 — MAC-V Evidence Status

```text
Runtime Preflight                    PASS
SSH Socket Activation               CONFIRMED
/run/sshd Runtime Directory         PASS
sshd -t                             PASS
Effective SSH Baseline              port 22 / permitrootlogin without-password
UFW Baseline                        inactive
Pre-change TCP 22 Authentication    NOT RUN
SSH 20022                           NOT RUN
UFW Final Policy                    NOT RUN
Users / Groups / ACL                NOT RUN
Agent                               NOT RUN
Monitor / Log / Cron                NOT RUN
Integrated Verify                   NOT RUN
Mission CLEAR                       NO
```

현재 다음 Gate는 **macOS Host → Ubuntu OpenSSH TCP 22 비-root 실제 인증 확인**입니다. 이 Gate 전에는 TCP 20022 변경을 적용하지 않습니다.
