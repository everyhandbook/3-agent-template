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

## 정상 운영 플로우

1. `.claude` 원본을 수정합니다.
2. sync 스크립트를 실행합니다.
3. `.agent`, `.agents` 반영 결과를 확인합니다.
4. 필요하면 `task.md`, `docs/session-logs/`, `docs/lessons.md`에 운영 메모를 남깁니다.

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
