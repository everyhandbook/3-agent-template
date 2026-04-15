# 워크플로우 및 스킬 작성 규칙

이 템플릿은 `공통 workflow`와 `도구별 skill`을 구분해서 운영합니다.

## 구조

- `.claude/commands/`
  - 공통 workflow 원본
- `.agent/workflows/`
  - Antigravity 실행 미러
- `.claude/skills/`
  - Claude Code용 skills
- `.agents/skills/`
  - Codex 전용 skills
- `.agent/skills/`
  - Antigravity 전용 skills

## 실행 방식

- Claude Code
  - `.claude/skills/` 우선
  - 공통 workflow는 `.claude/commands/` 사용 가능
- Antigravity
  - `.agent/skills/` 자동 활성화
  - `.agent/workflows/`는 `/명령어`로 실행
- Codex
  - `.agents/skills/` 우선
  - 공통 workflow는 문서 또는 자연어 요청으로 수행

## 기본 제공 운영 자산

이 템플릿은 아래 자산을 기본 세트로 유지합니다.

- `.agents/skills/session-start/`
- `.agents/skills/checkpoint/`
- `.agents/skills/session-wrap-up/`
- `.agents/skills/agent-handoff/`
- `docs/lessons.md`

`checkpoint`는 경량 커밋용, `session-wrap-up`은 세션 종료용입니다.
`agent-handoff`는 `brief`, `review`, `handoff`, `status` 문서를 작성하는 범용 skill입니다.

## 작성 원칙

1. 공통 workflow는 `.claude/commands/`에 작성합니다.
2. 공통 규칙은 `.claude/rules/`에 작성합니다.
3. Codex 전용 skill은 `.agents/skills/{name}/SKILL.md`에 작성합니다.
4. Antigravity 전용 skill은 `.agent/skills/`에 작성합니다.
5. `.agent` 미러는 직접 수정하지 않고 sync로 반영합니다.
6. 세션 운영 규칙을 바꾸는 경우 `docs/lessons.md` 확인 및 반영 절차와 충돌하지 않는지 함께 점검합니다.

## 동기화

- `.claude/commands/*.md` -> `.agent/workflows/*.md`
- `.claude/rules/*.md` -> `.agent/rules/*.md`
- `.claude/skills/*/SKILL.md` -> `.agent/workflows/{name}.md`

즉, 공통 자산은 항상 `.claude`에서 먼저 수정합니다.
