#!/usr/bin/env bash
set -uo pipefail

EXPECTED_REPO="MetaStudy999/codyssey-basic-system-monitor"
EXPECTED_DIR="codyssey-basic-system-monitor"
EXPECTED_MISSION="B4-1"
CONTEXT=""
PASS=0
WARN=0
FAIL=0

usage() {
  cat <<'EOF'
Usage:
  bash runtime-preflight.sh --context MAC-V
  bash runtime-preflight.sh --context WIN-V

이 스크립트는 B4-1 실제 시스템 변경 전에 현재 Ubuntu/Repository/도구/기존 상태를
읽기 전용으로 점검합니다. SSH/UFW/User/ACL/Agent/cron 설정을 변경하지 않습니다.
EOF
}

pass() { printf '[PASS] %s\n' "$*"; PASS=$((PASS + 1)); }
warn() { printf '[WARN] %s\n' "$*"; WARN=$((WARN + 1)); }
fail() { printf '[FAIL] %s\n' "$*" >&2; FAIL=$((FAIL + 1)); }
info() { printf '[INFO] %s\n' "$*"; }

while (($#)); do
  case "$1" in
    --context)
      shift
      (($#)) || { usage; exit 2; }
      CONTEXT="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf '[FAIL] unknown argument: %s\n' "$1" >&2
      usage
      exit 2
      ;;
  esac
  shift
done

case "$CONTEXT" in
  MAC-V|WIN-V) ;;
  *)
    printf '[FAIL] --context MAC-V 또는 --context WIN-V를 명시해야 합니다.\n' >&2
    usage
    exit 2
    ;;
esac

printf '===== B4-1 Runtime Preflight — READ ONLY =====\n'
printf 'Current Runtime Context: %s\n\n' "$CONTEXT"

# 1. Linux / Ubuntu
if [[ "$(uname -s 2>/dev/null || true)" == "Linux" ]]; then
  pass 'Linux runtime'
else
  fail "Linux runtime이 아닙니다: $(uname -s 2>/dev/null || echo unknown)"
fi

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  info "OS=${ID:-unknown} VERSION_ID=${VERSION_ID:-unknown}"
  if [[ "${ID:-}" == "ubuntu" && "${VERSION_ID:-}" == "24.04" ]]; then
    pass 'Ubuntu 24.04'
  else
    fail "R01 권장 Runtime Ubuntu 24.04가 아닙니다: ID=${ID:-unknown} VERSION_ID=${VERSION_ID:-unknown}"
  fi
else
  fail '/etc/os-release를 읽을 수 없습니다'
fi

ARCH="$(uname -m 2>/dev/null || true)"
if [[ -n "$ARCH" ]]; then
  pass "architecture=$ARCH"
else
  fail 'CPU architecture 확인 실패'
fi

PID1="$(ps -p 1 -o comm= 2>/dev/null | tr -d '[:space:]')"
if [[ "$PID1" == "systemd" ]]; then
  pass 'PID 1 = systemd'
else
  fail "PID 1이 systemd가 아닙니다: ${PID1:-unknown}"
fi

# 2. Runtime context consistency
KERNEL_TEXT="$(uname -r 2>/dev/null || true) $(cat /proc/version 2>/dev/null || true)"
if [[ "$CONTEXT" == "WIN-V" ]]; then
  if grep -Eqi 'microsoft|wsl' <<<"$KERNEL_TEXT" || [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
    pass 'WIN-V WSL2 marker detected'
  else
    warn 'WIN-V로 지정했지만 WSL marker를 확인하지 못했습니다. Host/WSL 상태를 직접 확인하세요.'
  fi
else
  if grep -Eqi 'microsoft|wsl' <<<"$KERNEL_TEXT" || [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
    fail 'MAC-V로 지정했지만 WSL marker가 감지되었습니다'
  elif grep -Eqi 'orbstack' <<<"$KERNEL_TEXT" || [[ -d /mnt/mac ]]; then
    pass 'MAC-V OrbStack marker detected'
  else
    warn 'MAC-V로 지정했지만 OrbStack marker를 확정하지 못했습니다. macOS Host → OrbStack Ubuntu인지 직접 확인하세요.'
  fi
fi

# 3. Required commands — no installation
required_commands=(bash git grep awk sed ss ps pgrep df stat getfacl runuser systemctl crontab file unzip)
for cmd in "${required_commands[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    pass "command available: $cmd"
  else
    fail "required command missing: $cmd"
  fi
done

if command -v ufw >/dev/null 2>&1; then
  pass 'command available: ufw'
else
  fail 'required command missing: ufw'
fi

if [[ -x /usr/sbin/sshd ]] || command -v sshd >/dev/null 2>&1; then
  pass 'OpenSSH server binary available'
else
  fail 'OpenSSH server binary를 찾을 수 없습니다'
fi

# 4. Repository identity
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  pass "Git worktree: $ROOT"
else
  fail '현재 위치가 Git Repository가 아닙니다'
  ROOT=""
fi

if [[ -n "$ROOT" ]]; then
  if [[ "$(basename "$ROOT")" == "$EXPECTED_DIR" ]]; then
    pass "canonical directory name: $EXPECTED_DIR"
  else
    warn "Repository directory name이 권장값과 다릅니다: $(basename "$ROOT")"
  fi

  ORIGIN="$(git -C "$ROOT" remote get-url origin 2>/dev/null || true)"
  info "origin=${ORIGIN:-<none>}"
  if [[ "$ORIGIN" == *"$EXPECTED_REPO"* ]]; then
    pass 'canonical origin'
  else
    fail "origin이 Canonical Repository를 가리키지 않습니다: ${ORIGIN:-<none>}"
  fi

  if [[ -f "$ROOT/MISSION-METADATA.yml" ]] \
     && grep -Fxq "current_mission_id: $EXPECTED_MISSION" "$ROOT/MISSION-METADATA.yml" \
     && grep -Fxq "repository: $EXPECTED_REPO" "$ROOT/MISSION-METADATA.yml"; then
    pass 'MISSION-METADATA.yml current B4-1 mapping'
  else
    fail 'MISSION-METADATA.yml current B4-1 mapping 확인 실패'
  fi

  BRANCH="$(git -C "$ROOT" branch --show-current 2>/dev/null || true)"
  info "branch=${BRANCH:-<detached>}"
  if [[ -n "$(git -C "$ROOT" status --porcelain 2>/dev/null)" ]]; then
    fail 'Git working tree에 예상하지 않은 변경이 있습니다. 변경을 검토한 뒤 진행하세요.'
    git -C "$ROOT" status --short || true
  else
    pass 'Git working tree clean'
  fi

  if [[ -f "$ROOT/agent-app.zip" ]]; then
    pass 'provided agent-app.zip exists'
  else
    fail 'provided agent-app.zip missing at repository root'
  fi

  if bash -n "$ROOT/training/round-01-clear/monitor.sh"; then
    pass 'monitor.sh static syntax'
  else
    fail 'monitor.sh Bash syntax error'
  fi
fi

# 5. Read-only current service/resource snapshot
printf '\n===== Current Baseline Snapshot =====\n'
if systemctl is-active --quiet ssh 2>/dev/null; then
  pass 'ssh.service currently active'
else
  warn 'ssh.service currently inactive or unavailable — 이후 SSH STEP에서 확인 필요'
fi

info 'current TCP listeners (20022 / 15034 / 22 if present):'
ss -ltn 2>/dev/null | awk 'NR==1 || $4 ~ /:(22|20022|15034)$/' || true

if sudo -n true >/dev/null 2>&1; then
  info 'sudo credential available non-interactively; UFW current status follows'
  sudo -n ufw status verbose 2>/dev/null || warn 'UFW status 조회 실패'
else
  warn 'sudo non-interactive credential 없음 — 시스템 변경 전 sudo 인증 후 현재 UFW/SSH 상태를 별도로 백업해야 합니다'
fi

for account in agent-admin agent-dev agent-test; do
  if getent passwd "$account" >/dev/null 2>&1; then
    info "existing user: $account"
  else
    info "user not present yet: $account"
  fi
done
for group in agent-common agent-core; do
  if getent group "$group" >/dev/null 2>&1; then
    info "existing group: $group"
  else
    info "group not present yet: $group"
  fi
done

[[ -e /opt/agent-app ]] && info 'existing path: /opt/agent-app' || info 'path not present yet: /opt/agent-app'
[[ -e /var/log/agent-app ]] && info 'existing path: /var/log/agent-app' || info 'path not present yet: /var/log/agent-app'

printf '\n===== Summary =====\n'
printf 'PASS=%d WARN=%d FAIL=%d\n' "$PASS" "$WARN" "$FAIL"
printf 'Mode: READ ONLY — no SSH/UFW/User/ACL/Agent/cron configuration was changed.\n'

if ((FAIL == 0)); then
  printf '[PASS] B4-1 Runtime Preflight\n'
  printf 'NEXT: Beginner Guide module 01 baseline → module 02 SSH/UFW.\n'
  printf 'NOTE: Preflight PASS ≠ Runtime PASS ≠ Mission CLEAR.\n'
  exit 0
fi

printf '[FAIL] B4-1 Runtime Preflight: %d blocker(s)\n' "$FAIL" >&2
printf 'Fix only the reported blockers, then rerun this preflight.\n' >&2
exit 1
