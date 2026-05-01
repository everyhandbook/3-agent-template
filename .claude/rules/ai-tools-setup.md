---
trigger: always_on
description: AI 도구 설정 및 역할 구분 (Antigravity, Claude Code, Codex)
---

# AI Tools Setup

이 템플릿은 `Claude Code`, `Google Antigravity`, `Codex`를 함께 사용하는 프로젝트를 위한 기본 구조를 제공합니다.

## Google Antigravity

- Rules: `.agent/rules/`
- Skills: `.agent/skills/`
- Workflows: `.agent/workflows/`

## Claude Code

- 공통 원본: `.claude/rules/`, `.claude/skills/`
- Claude shared skills: `.claude/skills/{name}/SKILL.md`

## Codex

- 공통 운영 가이드: `AGENTS.md`
- Codex skill mirror: `.agents/skills/`
- Codex rules entrypoint: repo 루트의 `AGENTS.md`
- `.agents/rules/`는 만들지 않음
- 공통 미러 참조: `.agent/rules/`, `.agent/skills/`, `.agent/workflows/`

기본 제공 운영 자산:
- `session-start`
- `checkpoint`
- `session-wrap-up`
- `agent-handoff`
- `docs/lessons.md`

## 운영 원칙

- 공통 운영 자산은 `.claude`에서 먼저 수정합니다.
- 공통 rules 중 Codex가 반드시 알아야 하는 내용은 `AGENTS.md`에도 명시합니다.
- `.agent`, `.agents/skills`는 실행 미러이므로 직접 수정하지 않습니다.
- shared skill은 skill-first 구조로 `.claude/skills/`에 둡니다.
- `agent-handoff`는 범용 handoff 문서용 기본 skill입니다.
