# 워크플로우 및 스킬 작성 규칙

이 템플릿은 `shared skill`을 원본으로 두고, 필요 시 workflow 호환 미러를 함께 운영합니다.

## 구조

- `.claude/commands/`
  - 사용하지 않음
- `.agent/workflows/`
  - Antigravity workflow compatibility mirror
- `.claude/skills/`
  - shared skill 원본
- `.agents/skills/`
  - Codex skill mirror
- `.agent/skills/`
  - Antigravity skill mirror

## 실행 방식

- Claude Code
  - `.claude/skills/` 우선
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

1. 공통 skill은 `.claude/skills/`에 작성합니다.
2. 공통 규칙은 `.claude/rules/`에 작성합니다.
3. `SKILL.md`에는 frontmatter의 `name`, `description`을 포함합니다.
4. Codex UI 노출이 필요하면 `agents/openai.yaml`을 함께 둡니다.
5. `.agent`, `.agents` 미러는 직접 수정하지 않고 sync로 반영합니다.
6. 세션 운영 규칙을 바꾸는 경우 `docs/lessons.md` 확인 및 반영 절차와 충돌하지 않는지 함께 점검합니다.

## 동기화

- `.claude/rules/*.md` -> `.agent/rules/*.md`
- `.claude/skills/*/*` -> `.agents/skills/*/*`
- `.claude/skills/*/*` -> `.agent/skills/*/*`
- `.claude/skills/*/SKILL.md` -> `.agent/workflows/{name}.md`

즉, 공통 자산은 항상 `.claude`에서 먼저 수정합니다.
