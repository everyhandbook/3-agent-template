---
trigger: always_on
description: .claude/와 .agent/ 간 동기화 규칙
---

# 3-Agent 동기화 규칙

이 템플릿은 `.claude`를 단일 원본으로 두고 `.agent`에 실행 미러를 유지합니다.

## 동기화 대상

| 작성 원본 (.claude) | 실행 미러 (.agent) | 동기화 정책 |
|---|---|---|
| `.claude/rules/*.md` | `.agent/rules/*.md` | 기본 단방향 |
| `.claude/commands/*.md` | `.agent/workflows/*.md` | 기본 단방향 |
| `.claude/skills/*/SKILL.md` | `.agent/workflows/{name}.md` | flatten sync |
| `.agent/skills/*` | 해당 없음 | 제외 |
| `.agents/skills/*` | 해당 없음 | 제외 |

## 정상 운영 플로우

1. `.claude` 원본을 수정합니다.
2. sync 스크립트를 실행합니다.
3. `.agent` 반영 결과를 확인합니다.

## 주의사항

- `.agent`는 평시 직접 수정하지 않습니다.
- Codex 전용 skill과 Antigravity 전용 skill은 별도 관리합니다.
