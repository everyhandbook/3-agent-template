# [프로젝트명] - Codex 운영 가이드

이 파일은 이 레포지토리에서 AI 에이전트(Codex 등)가 따라야 할 기본 운영 지침서입니다.

## 목표

다음 3개 에이전트가 단일 소스(Single Source)를 기반으로 협업합니다.
- Claude Code
- Google Antigravity
- Codex (Cursor/IDE)

## 단일 원본 정책 (Single Source of Truth)

- **작성 원본**: `.claude` 
  - 규칙과 워크플로우를 여기서 먼저 작성하고 수정합니다.
- **실행 미러**: `.agent`
  - Antigravity 등 다른 에이전트가 참조하는 읽기 전용 미러입니다.
  - 평시에는 `.agent` 파일을 직접 수정하지 않습니다.

## 경로 매핑

| 작성 원본 (Claude) | 실행 미러 (Antigravity/Codex) | 목적 |
|---|---|---|
| `.claude/commands/*.md` | `.agent/workflows/*.md` | 실행 가능한 워크플로우 정의 |
| `.claude/rules/*.md` | `.agent/rules/*.md` | 프로젝트 규칙 및 가이드라인 |

## 세션 시작 체크리스트

1. `task.md`를 읽고 현재 진행 상황을 파악합니다.
2. `docs/session-logs/`의 최신 로그를 확인하여 이전 작업 맥락을 이어서 진행합니다. (필요 시)
3. `README.md`를 읽고 프로젝트의 핵심 목표를 상기합니다.
4. `.claude`의 규칙이나 워크플로우가 변경되었다면 동기화 스크립트를 실행합니다.

## 세션 종료 체크리스트

1. `task.md`를 업데이트합니다.
   - 완료된 작업은 `완료 (Done)` 처리
   - `다음 단계 (Next Steps)` 갱신
2. 세션 로그를 작성하여 `docs/session-logs/`에 저장합니다.
   - 날짜, 수행 작업, 변경 파일, 메모 등 포함
3. `.claude` 폴더 내 변경사항이 있다면 동기화를 실행하고 검증합니다.

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
