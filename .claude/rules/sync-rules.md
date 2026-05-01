---
trigger: always_on
description: .claude/와 .agent/ 간 동기화 규칙
---

# 3-Agent 동기화 규칙

이 템플릿은 `.claude`를 단일 원본으로 두고 `.agent`, `.agents`에 실행 미러를 유지합니다.

## 동기화 대상

| 작성 원본 (.claude) | 실행 미러 (.agent) | 동기화 정책 |
|---|---|---|
| `.claude/rules/*.md` | `.agent/rules/*.md` | 기본 단방향 |
| `.claude/skills/*/*` | `.agents/skills/*/*` | 디렉터리 미러 |
| `.claude/skills/*/*` | `.agent/skills/*/*` | 디렉터리 미러 |
| `.claude/skills/*/SKILL.md` | `.agent/workflows/{name}.md` | workflow compatibility flatten sync |

## Codex rules 처리

Codex에는 `.agents/rules/` 폴더를 두지 않습니다. Codex가 공통 운영 규칙을 확인하는 entrypoint는 repo 루트의 `AGENTS.md`입니다.

`.agents/skills/`는 Codex용 skill mirror 위치이며 rules 위치가 아닙니다.

## 정상 운영 플로우

1. `.claude` 원본을 수정합니다.
2. **미러는 자동 동기화됩니다** — sync 스크립트를 직접 실행할 필요 없습니다.
3. 필요하면 `task.md`, `docs/session-logs/`, `docs/lessons.md`에 운영 메모를 남깁니다.

## 자동 동기화 장치

이 템플릿은 두 계층으로 미러를 자동 갱신합니다. 에이전트(Claude / Codex / Antigravity)나 사람이 sync 명령을 **기억할 필요가 없습니다**.

- **Claude Code PostToolUse 훅** (`.claude/settings.json`)
  - Claude Code가 `.claude/` 아래 파일을 Edit/Write/MultiEdit으로 수정하면 즉시 sync 스크립트가 실행됩니다.
- **git pre-commit 훅** (`.githooks/pre-commit`)
  - 어떤 에이전트든 `.claude/` 변경을 staged 하면 커밋 직전에 sync가 돌고 `.agent`, `.agents` 변경이 같은 커밋에 포함됩니다.
  - 신규 클론 시 1회만: `bash scripts/install-hooks.sh` (또는 `.\scripts\install-hooks.ps1`).
- **수동 실행** (필요 시)
  - `bash scripts/sync-agent-files.sh` 또는 `.\scripts\sync-agent-files.ps1`.

Codex나 Antigravity에서 `.claude/`를 편집했더라도 git pre-commit 훅이 안전망 역할을 하므로 커밋 시점에 미러가 자동 갱신됩니다.

기본 운영 자산 점검:
- `session-start`
- `checkpoint`
- `session-wrap-up`
- `agent-handoff`
- `docs/lessons.md`

세션 운영 규칙을 건드린 경우에는 위 자산 설명과 실제 구조가 어긋나지 않는지 함께 점검합니다.

## 주의사항

- `.agent`, `.agents/skills`는 평시 직접 수정하지 않습니다.
- `.agent/workflows`는 Antigravity 호환을 위한 파생 산출물로 취급합니다.
