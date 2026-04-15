# [프로젝트명] - 3-Agent 운영 가이드

이 파일은 이 레포지토리에서 `Claude Code`, `Google Antigravity`, `Codex`가 같은 기준으로 협업하기 위한 공통 운영 가이드입니다.

## 목표

다음 3개 에이전트가 단일 소스(Single Source)를 기반으로 협업합니다.
- Claude Code
- Google Antigravity
- Codex

## 단일 원본 정책 (Single Source of Truth)

- **공통 원본**: `.claude`
  - 규칙, 공통 workflow, Claude용 공통 자산을 여기서 먼저 작성/수정합니다.
- **실행 미러**: `.agent`
  - Antigravity 실행용 미러입니다.
  - 평시에는 `.agent`를 직접 수정하지 않습니다.
- **Codex 전용 skill**: `.agents/skills`
  - Codex에서만 쓰는 skill은 별도 위치에서 관리합니다.

## 경로 매핑

| 작성 원본 | 실행 미러 | 목적 |
|---|---|---|
| `.claude/commands/*.md` | `.agent/workflows/*.md` | 공통 workflow |
| `.claude/rules/*.md` | `.agent/rules/*.md` | 공통 규칙 |
| `.claude/skills/*/SKILL.md` | `.agent/workflows/{name}.md` | Claude skill을 Antigravity workflow로 flatten sync |
| `.agents/skills/*/SKILL.md` | 동기화 없음 | Codex 전용 skill |
| `.agent/skills/*` | 동기화 없음 | Antigravity 전용 skill |

## 에이전트별 실행 방식

- **Claude Code**
  - `.claude/skills/`를 우선 사용
  - 공통 workflow는 `.claude/commands/`를 함께 사용 가능
- **Google Antigravity**
  - `.agent/skills/`는 자동 활성화용
  - `.agent/workflows/`는 명시형 `/명령어` 실행용
- **Codex**
  - `.agents/skills/`를 우선 사용
  - 공통 운영 규칙은 `AGENTS.md`, `.claude`, `.agent` 문서를 함께 참조

## 기본 제공 운영 자산

이 템플릿은 아래 자산을 공용 기본 세트로 제공합니다.

- `session-start`
  - 새 세션에서 현재 상태와 다음 작업을 빠르게 파악하는 시작 skill
- `checkpoint`
  - 세션을 닫지 않고 현재 작업만 정리해 로컬 커밋으로 남기는 경량 skill
- `session-wrap-up`
  - 세션 종료 시 `task.md`, 세션 로그, `docs/lessons.md` 반영 여부를 정리하는 종료 skill
- `agent-handoff`
  - 다른 agent에게 `brief`, `review`, `handoff`, `status` 문서를 남기는 범용 skill
- `docs/lessons.md`
  - 반복되는 운영 교훈과 개선점을 누적하는 기본 문서

## 세션 시작 체크리스트

1. `task.md`를 읽고 현재 진행 상황을 파악합니다.
2. `docs/session-logs/`의 최신 로그를 확인하여 이전 작업 맥락을 이어서 진행합니다. 필요할 때만 확인해도 됩니다.
3. `README.md`를 읽고 프로젝트의 핵심 목표를 상기합니다.
4. `.claude`의 규칙, workflow, 공통 skill이 변경되었다면 동기화 스크립트를 실행합니다.
5. `docs/lessons.md`가 있으면 최근 교훈을 확인합니다.

## 세션 종료 체크리스트

1. `task.md`를 업데이트합니다.
   - 완료된 작업은 `완료 (Done)` 처리
   - `다음 단계 (Next Steps)` 갱신
2. 세션 로그를 작성하여 `docs/session-logs/`에 저장합니다.
   - 날짜, 수행 작업, 변경 파일, 메모 등 포함
3. `.claude` 폴더 내 변경사항이 있다면 동기화를 실행하고 검증합니다.
4. 반복 가능성이 큰 교훈이 생겼다면 `docs/lessons.md` 반영 여부를 검토합니다.

## 동기화 명령

작업 환경에 따라 아래 명령 중 하나를 사용합니다.

```bash
# Bash (기본: .claude -> .agent)
./scripts/sync-agent-files.sh
./scripts/sync-agent-files.sh --from claude

# 복구 모드 (역방향: .agent -> .claude)
# 실수로 .agent를 수정했을 때만 사용
./scripts/sync-agent-files.sh --from agent
```

```powershell
# PowerShell (기본: .claude -> .agent)
.\scripts\sync-agent-files.ps1
.\scripts\sync-agent-files.ps1 -From claude

# 복구 모드 (역방향)
.\scripts\sync-agent-files.ps1 -From agent
```

## 현재 범위

- 이번 단계에서는 pre-commit/CI 강제 동기화는 적용하지 않습니다.
- Codex 전용 skill은 현재 `session-start`, `checkpoint`, `session-wrap-up`, `agent-handoff`를 기본 제공 세트로 관리합니다.
