# B4-1 — 지금 실행하기(Runtime Entry)

> 현재 Mission ID: **B4-1** / 이전 ID: **B1-1**  
> Canonical Repository: `MetaStudy999/codyssey-basic-system-monitor`

이 문서는 B4-1 시스템 관제의 실제 Ubuntu 설정을 변경하기 전에 **현재 실행 환경과 Repository를 읽기 전용으로 확인**하기 위한 진입점입니다.

```text
Runtime Context 선택
→ Canonical Repository 준비
→ runtime-preflight.sh
→ 0 FAIL
→ Beginner Guide module 01 Baseline
→ module 02 SSH/UFW
→ users/groups/ACL
→ Agent
→ monitor/log
→ cron/tests
→ Verification/Evidence
→ CLEAR Gate
```

`runtime-preflight.sh` 자체는 SSH, UFW, 사용자, 그룹, ACL, Agent, cron을 변경하지 않습니다.

## 1. 현재 Runtime Context 선택

둘 중 실제 작업 위치 하나를 선택합니다.

```text
MAC-V
학교 macOS → OrbStack → Ubuntu 24.04

WIN-V
Windows 11 Pro → WSL2 → Ubuntu 24.04
```

B2-2에서 어떤 환경을 사용했는지와 무관하게 B4-1을 시작할 때 현재 위치를 다시 선택합니다.

## 2. Canonical Repository 준비

Ubuntu Bash에서 실행합니다.

```bash
set -e

ROOT="$HOME/codyssey"
REPO="$ROOT/codyssey-basic-system-monitor"
URL="https://github.com/MetaStudy999/codyssey-basic-system-monitor.git"

mkdir -p "$ROOT"

if [ -d "$REPO/.git" ]; then
    echo '[INFO] existing B4-1 repository found'
    if [ -n "$(git -C "$REPO" status --porcelain)" ]; then
        echo '[STOP] local changes exist; refusing automatic pull' >&2
        git -C "$REPO" status --short
        exit 1
    fi
    git -C "$REPO" remote set-url origin "$URL"
    git -C "$REPO" pull --ff-only
elif [ -e "$REPO" ]; then
    echo '[STOP] path exists but is not a Git repository:' >&2
    echo "$REPO" >&2
    exit 1
else
    git clone "$URL" "$REPO"
fi

cd "$REPO"
git remote -v
git status --short --branch
```

기존 Repository의 로컬 변경을 자동으로 지우거나 `reset --hard`하지 않습니다.

## 3. 읽기 전용 Runtime Preflight

### MAC-V

```bash
cd "$HOME/codyssey/codyssey-basic-system-monitor"
bash training/round-01-clear/environment/runtime-preflight.sh --context MAC-V
```

### WIN-V

```bash
cd "$HOME/codyssey/codyssey-basic-system-monitor"
bash training/round-01-clear/environment/runtime-preflight.sh --context WIN-V
```

정상 종료 기준:

```text
PASS=n WARN=m FAIL=0
[PASS] B4-1 Runtime Preflight
```

`WARN`은 현재 상태를 확인해야 하는 항목입니다. `FAIL`이 하나라도 있으면 SSH/UFW 변경을 시작하지 않습니다.

## 4. Preflight가 확인하는 것

```text
Linux / Ubuntu 24.04
CPU architecture
PID 1 = systemd
MAC-V / WIN-V marker
필수 command 존재
OpenSSH Server / UFW command 존재
Git Repository / canonical origin
MISSION-METADATA.yml = B4-1
clean working tree
agent-app.zip 존재
monitor.sh Bash 문법
현재 ssh.service 상태
현재 22/20022/15034 listener snapshot
가능할 때 UFW 읽기 전용 snapshot
기존 agent-* users/groups/path 상태
```

확인하지 않는 것:

```text
SSH 20022 실제 접속 성공
최종 UFW 정책
Agent Boot 5/5
Agent READY
15034 최종 LISTEN
monitor 정상/실패/Warning Runtime
10MB/10개 log rotation
cron 실제 증가
통합 verify 0 FAIL
Evidence Complete
Mission CLEAR
```

위 항목은 이후 실제 단계에서만 PASS 판정합니다.

## 5. Preflight PASS 후 이동

```text
training/round-01-clear/BEGINNER-GUIDE.md
→ guide/01-preflight-baseline/
→ guide/02-ssh-firewall/
```

특히 SSH/UFW는 다음 순서를 생략하지 않습니다.

```text
현재 상태
→ 백업
→ 20022 선허용
→ sshd -t
→ sshd -T
→ reload
→ 20022 LISTEN
→ 실제 새 SSH 세션 성공
→ 기존 경로 정리 여부 판단
→ 최종 UFW 정책
```

새 20022 세션을 실제로 확인하기 전에 기존 접속 경로를 제거하지 않습니다.

## 6. Secret 보호

`t_secret.key` 실제 값은 다음에 기록하지 않습니다.

```text
GitHub
Chat
Evidence
Screenshot
Log
```

Secret 준비 단계에서는 공식 Source를 사용자가 직접 확인하고 로컬 터미널에서 비표시 입력으로 처리합니다. 검증은 값 대신 존재·크기·소유권·그룹·mode·effective access와 Agent Boot 결과를 사용합니다.

## 상태 판정

```text
Runtime Entry Runbook       ✅ READY
Read-only Preflight Runner  ✅ READY
Actual Runtime              ⬜ NOT RUN
Verification                ⬜ NOT RUN
Evidence                    ⬜ NOT RUN
B4-1 Mission CLEAR          ❌ 아님
```
