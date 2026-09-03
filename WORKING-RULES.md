# B4-1 작업 룰(Working Rules)

이 문서는 현재 **B4-1 시스템 관제**에서 사용하는 **미션별 작업 운영 어댑터(Mission Working Rules Adapter)**입니다. 이 미션은 번호 변경 전 B1-1이었으며, 공통 규칙 전문을 복제하지 않고 메인 레포(Control Tower)의 상위 표준을 사용합니다.

## 빠른 적용(Quick Apply)

```text
B4-1 공식 Mission / Evaluation / 제공 파일
→ MISSION-METADATA.yml 현재 ID/Repository 확인
→ codyssey-basic-system-monitor main
→ Control Tower 상위 작업 운영 표준
→ BEGINNER-GUIDE / CHECKLIST
→ 실제 실행(Runtime Execution)
→ 검증(Verification)
→ 증빙 자료(Evidence)
→ 평가(Evaluation)
→ 조건 충족 시에만 B4-1 CLEAR
```

> `b1-1-mission.pdf`, `b1-1-mission.md`, `b1-1-evaluation.md` 파일명은 번호 변경 전 공식 Source의 역사적 식별자로 보존합니다. 현재 운영 ID는 B4-1입니다.

## 📑 목차

- [기준 우선순위](#priority)
- [공통 작업 운영 표준](#standard)
- [B4-1 실행 문서](#local)
- [상태와 실행 규칙](#runtime)
- [변경 관리](#change)

<a id="priority"></a>
## 기준 우선순위

```text
1. 시스템 관제 공식 Mission / Evaluation / 제공 파일
2. MISSION-METADATA.yml + Control Tower CURRENT-MISSION-MAP.md
3. 이 Repository의 실제 main
4. Control Tower 실제 main
5. Control Tower standards/
6. B4-1 학습·실행 문서
```

공식 요구사항과 내부 표준이 충돌하면 공식 요구사항이 우선합니다. Mission ID/Repository 연결은 현재 Metadata와 Control Tower 기준을 따릅니다.

<a id="standard"></a>
## 공통 작업 운영 표준

- [Codyssey Working Operating Standard](https://github.com/MetaStudy999/codyssey-basic/blob/main/standards/CODYSSEY-WORKING-OPERATING-STANDARD.md)
- [Current Mission Map](https://github.com/MetaStudy999/codyssey-basic/blob/main/CURRENT-MISSION-MAP.md)

세부 용어·모듈화·환경·명령 설명·검증·증빙 규칙도 위 메인 레포 `standards/`를 사용합니다.

<a id="local"></a>
## B4-1 실행 문서

- [`README.md`](README.md) — 미션 진입
- [`training/round-01-clear/BEGINNER-GUIDE.md`](training/round-01-clear/BEGINNER-GUIDE.md) — 전체 중앙 허브(Global Hub)
- [`training/round-01-clear/CHECKLIST.md`](training/round-01-clear/CHECKLIST.md) — 실제 완료 판정
- [`training/round-01-clear/environment/`](training/round-01-clear/environment/) — 실행 환경·검증
- [`training/round-01-clear/evidence/`](training/round-01-clear/evidence/) — 실제 증빙 자료(Evidence)

<a id="runtime"></a>
## 상태와 실행 규칙

```text
Documentation Ready
≠ BEGINNER READY
≠ Runtime PASS
≠ Verification PASS
≠ Evidence Complete
≠ Mission CLEAR
```

실제 Runtime에서는 **Preflight → 한 단계 실행 → 실제 출력 → STOP/GO → 검증 → 다음 단계** 순서를 사용합니다. 실제 결과 없이 PASS/CLEAR를 기록하지 않습니다.

B4-1은 SSH/UFW를 다루므로 새 SSH 20022 세션이 실제로 검증되기 전에 기존 접속 경로를 제거하지 않습니다.

비밀정보(Secret)는 값이 아니라 존재·경로·소유권·그룹·권한 등 메타데이터 중심으로 검증합니다.

<a id="change"></a>
## 변경 관리

```text
최신 main 확인
→ 대상 파일 현재 상태/SHA 확인
→ 최소 변경
→ Commit
→ 실제 GitHub main 재확인
→ APPLY & VERIFY
```

이 문서에는 B4-1 고유 예외만 추가하고, 공통 작업 룰 전문을 복제하지 않습니다.
