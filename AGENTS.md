# [프로젝트명] - 3-Agent 운영 가이드

이 파일은 이 레포지토리에서 `Claude Code`, `Google Antigravity`, `Codex`가 같은 기준으로 협업하기 위한 공통 운영 가이드입니다.

## 목표

다음 3개 에이전트가 단일 소스(Single Source)를 기반으로 협업합니다.
- Claude Code
- Google Antigravity
- Codex

## 커뮤니케이션 규칙

- 사용자를 부를 때는 기본 호칭으로 `사용자님`을 사용합니다.
- 다만 모든 문장마다 반복하지 말고, 자연스러운 위치에서만 사용합니다.
- 문서와 응답의 톤은 공손하지만 과하게 딱딱하지 않게 유지합니다.

## 단일 원본 정책 (Single Source of Truth)

- **공통 원본**: `.claude`
  - 규칙과 shared skill을 여기서 먼저 작성/수정합니다.
- **실행 미러**: `.agent`
  - Antigravity 실행용 미러입니다.
  - 평시에는 `.agent`를 직접 수정하지 않습니다.
- **Codex 미러**: `.agents/skills`
  - `.claude/skills`를 Codex에서 읽기 좋은 구조로 미러링합니다.

## 경로 매핑

| 작성 원본 | 실행 미러 | 목적 |
|---|---|---|
| `.claude/skills/*/SKILL.md` | `.agents/skills/*/SKILL.md` | Codex shared skill mirror |
| `.claude/skills/*/SKILL.md` | `.agent/skills/*/SKILL.md` | Antigravity skill mirror |
| `.claude/skills/*/SKILL.md` | `.agent/workflows/{name}.md` | Antigravity workflow compatibility mirror |
| `.claude/rules/*.md` | `.agent/rules/*.md` | 공통 규칙 |

## 에이전트별 실행 방식

- **Claude Code**
  - `.claude/skills/`, `.claude/rules/`를 우선 사용
- **Google Antigravity**
  - `.agent/skills/`, `.agent/workflows/`, `.agent/rules/`를 사용
- **Codex**
  - `.agents/skills/`를 우선 사용
  - 공통 운영 규칙은 `AGENTS.md`, `.claude`, `.agent` 문서를 함께 참조

## 기본 제공 운영 자산

이 템플릿은 아래 자산을 공용 기본 세트로 제공합니다.

- `session-start`
  - 새 세션에서 현재 상태와 다음 작업을 빠르게 파악하는 시작 skill
- `checkpoint`
  - 세션을 닫지 않고 현재 작업만 정리하고 관련 파일만 골라 로컬 커밋으로 남기는 경량 skill
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
4. `.claude`의 규칙과 shared skill이 변경되었다면 동기화 스크립트를 실행합니다.
5. `docs/lessons.md`가 있으면 최근 교훈을 확인합니다.
6. skill을 새로 만들거나 크게 수정할 때는 먼저 `skill-creator` 시스템 skill을 확인합니다.

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
- 기본 제공 skill은 현재 `session-start`, `checkpoint`, `session-wrap-up`, `agent-handoff`를 공용 세트로 관리합니다.
