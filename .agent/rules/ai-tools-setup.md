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

- 공통 원본: `.claude/rules/`, `.claude/commands/`
- Claude 전용 skills: `.claude/skills/{name}/SKILL.md`

## Codex

- 공통 운영 가이드: `AGENTS.md`
- Codex 전용 skills: `.agents/skills/`
- 공통 미러 참조: `.agent/rules/`, `.agent/workflows/`

## 운영 원칙

- 공통 운영 자산은 `.claude`에서 먼저 수정합니다.
- `.agent`는 실행 미러이므로 직접 수정하지 않습니다.
- Codex 전용 skill과 Antigravity 전용 skill은 sync 대상이 아닙니다.
