# 2026-04-15 Codex Template Agent Baseline

## 수행 작업

- `3-agent-template`에 공용 3-Agent 기본 세트를 보강했다.
- Codex용 범용 `agent-handoff` skill을 추가했다.
- `docs/lessons.md` 기본 템플릿을 추가했다.
- `AGENTS.md`, `README.md`, `.claude/rules/*`, `task.md`를 기본 운영 자산 기준으로 정합화했다.

## 변경 파일

- `AGENTS.md`
- `README.md`
- `.claude/rules/workflow.md`
- `.claude/rules/ai-tools-setup.md`
- `.claude/rules/sync-rules.md`
- `.agents/skills/agent-handoff/SKILL.md`
- `docs/lessons.md`
- `task.md`

## 메모

- 이 템플릿은 새 프로젝트에서 바로 복제해도 `session-start`, `checkpoint`, `session-wrap-up`, `agent-handoff`, `docs/lessons.md`를 기본 운영 자산으로 사용할 수 있게 됐다.
- 도메인 특화 handoff는 넣지 않고 범용 `agent-handoff`만 포함했다.

## 다음 단계

- 실제 새 프로젝트에서 sync와 checkpoint를 한 번 실행해 기본 흐름을 검증한다.
- 필요하면 Claude 전용 `.claude/skills/`와 Antigravity 전용 `.agent/skills/` 샘플도 후속으로 보강한다.
