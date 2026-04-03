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

## 작성 원칙

1. 공통 workflow는 `.claude/commands/`에 작성합니다.
2. 공통 규칙은 `.claude/rules/`에 작성합니다.
3. Codex 전용 skill은 `.agents/skills/{name}/SKILL.md`에 작성합니다.
4. Antigravity 전용 skill은 `.agent/skills/`에 작성합니다.
5. `.agent` 미러는 직접 수정하지 않고 sync로 반영합니다.

## 동기화

- `.claude/commands/*.md` -> `.agent/workflows/*.md`
- `.claude/rules/*.md` -> `.agent/rules/*.md`
- `.claude/skills/*/SKILL.md` -> `.agent/workflows/{name}.md`
