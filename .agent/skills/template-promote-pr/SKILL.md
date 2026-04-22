---
name: template-promote-pr
description: Assess whether a repo-specific workflow, rule, or skill improvement should also be applied to the shared 3-agent-template. Use when a user says a change may belong in the common template, wants that judgment made automatically, or wants the template repo updated and a PR prepared when appropriate.
---

# Template Promote PR

이 skill은 현재 저장소에서 나온 개선사항이 공용 템플릿 `3-agent-template`에도 반영할 가치가 있는지 판단하고, 적절하면 템플릿 저장소까지 반영해 PR 준비까지 이어가는 절차를 다룹니다.

## 승격 판단 기준

다음에 해당하면 템플릿 승격 후보로 봅니다.

- 여러 저장소/에이전트에서 반복될 가능성이 높은 운영 규칙
- 특정 도메인과 무관한 협업 방식, 보고 규칙, skill 구조
- 특정 프로젝트명이 아닌 공통 레포 구조에서 바로 재사용 가능한 내용

다음에 해당하면 현재 저장소에만 둡니다.

- 특정 용역, 특정 데이터 경로, 특정 고객/도메인 규칙
- 현재 레포의 장 구조나 보고서 자동화에만 묶인 로직
- 템플릿에 넣으면 오히려 과한 정책이 되는 내용

판단 결과는 항상 짧게 남깁니다.

- `공용 템플릿 반영 적합`
- `현재 저장소 전용 유지`

## 작업 순서

1. 현재 변경이 공용 템플릿에 적합한지 먼저 판단합니다.
2. 적합하면 `C:\Users\user\OneDrive\바탕 화면\Codex\3-agent-template`에서 최소 범위 수정만 합니다.
3. 수정은 `.claude` 원본 기준으로 하고, 필요하면 sync 스크립트로 `.agent`, `.agents`를 갱신합니다.
4. 현재 저장소 전용 설명은 템플릿 PR에 섞지 않습니다.
5. 가능하면 템플릿 저장소에 브랜치/커밋/푸시/PR까지 진행합니다.
6. PR이 불가능한 환경이면 비교 URL 또는 막힌 이유를 남깁니다.

## 템플릿 저장소 작업 원칙

- 템플릿 저장소 경로:
  - `C:\Users\user\OneDrive\바탕 화면\Codex\3-agent-template`
- 원본 수정 위치:
  - `.claude/skills/...`
  - `.claude/rules/...`
  - `AGENTS.md`
- 템플릿 저장소에서도 `.agent`, `.agents`는 파생 산출물로 취급합니다.

## 보고 형식

이 skill을 썼다면 결과를 아래 3줄로 정리합니다.

1. `템플릿 반영 적합 여부`
2. `실제로 반영한 파일`
3. `PR 링크 또는 미생성 사유`

## 주의

- "공용 템플릿에도 좋겠다"는 느낌만으로 승격하지 말고, 현재 저장소 고유 맥락이 빠져도 의미가 유지되는지 먼저 봅니다.
- 템플릿 PR에는 도메인 특화 예시보다 범용 표현을 우선 사용합니다.
- handoff, review, plan 문서는 한국어 통일 규칙을 유지합니다.
