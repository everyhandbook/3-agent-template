# 3-Agent 시스템 템플릿

이 레포지토리는 **단일 소스(Single Source)**를 기반으로 다양한 AI 에이전트(Claude Code, Google Antigravity, Codex)가 협업하는 템플릿 프로젝트입니다.

## 핵심 목적

1. **AI 에이전트 간의 설정 통일**
   - 하나의 진실(Single Source)을 유지하며 여러 에이전트가 동일한 규칙과 워크플로우를 참조하도록 합니다.
2. **워크플로우 자동화**
   - 반복적인 작업(세션 시작/종료, checkpoint, handoff 등)을 skill-first 구조와 스크립트로 운영합니다.
3. **문서 기반 운영**
   - 프로젝트의 모든 상태와 의사결정을 문서(`task.md`, `AGENTS.md`, `docs/session-logs/`, `docs/lessons.md`)에 기록하여 히스토리를 관리합니다.

## 디렉토리 구조

```text
.
├── .claude/                    # 규칙/shared skills의 단일 원본 (Primary)
│   ├── skills/                 # Claude Code shared skills
│   └── rules/                  # 프로젝트 전반의 규칙
├── .agent/                     # .claude의 읽기 전용 미러 (Mirror)
│   ├── workflows/              # Antigravity workflow compatibility mirror
│   ├── skills/                 # Antigravity skill mirror
│   └── rules/                  # Antigravity가 참조하는 규칙
├── .agents/                    # Codex skill mirror
│   └── skills/
├── docs/
│   ├── lessons.md              # 운영 교훈 누적 문서
│   └── session-logs/           # 세션 로그, brief, review, handoff, status
├── scripts/                    # 동기화 스크립트 (Bash/PowerShell)
├── AGENTS.md                   # 에이전트 운영 가이드
└── task.md                     # 프로젝트 진행 상황 추적
```

## 기본 제공 운영 자산

이 템플릿은 아래 운영 자산을 기본 제공 세트로 포함합니다.

- `session-start`
  - 새 세션에서 현재 상태와 다음 작업을 빠르게 파악하는 시작 skill
- `checkpoint`
  - 세션을 닫지 않고 현재 작업만 정리해 로컬 커밋으로 남기는 경량 skill
- `session-wrap-up`
  - 세션 종료 시 `task.md`, 세션 로그, `docs/lessons.md` 반영 여부를 정리하는 종료 skill
- `agent-handoff`
  - `brief`, `review`, `handoff`, `status` 문서를 남기는 범용 skill
- `docs/lessons.md`
  - 반복되는 운영 교훈과 개선점을 누적하는 기본 문서

## 시작하기

1. 이 템플릿을 복제(Clone)하거나 다운로드하여 새 프로젝트를 시작하세요.
2. `AGENTS.md`를 프로젝트에 맞게 수정합니다.
3. `.claude/rules/project-rules.md`에 프로젝트별 도메인 규칙이나 비즈니스 로직을 작성합니다.
4. 공통 절차를 만들고 싶다면 `.claude/skills/{name}/SKILL.md`를 생성하세요.
5. `SKILL.md`에는 frontmatter의 `name`, `description`을 포함하세요.
6. Codex UI 노출이 필요하면 `agents/openai.yaml`도 함께 추가하세요.
7. 신규 클론에서 **훅을 1회 설치**합니다 — 이후 동기화는 자동으로 돕니다.

```bash
bash scripts/install-hooks.sh
```

또는 Windows:

```powershell
.\scripts\install-hooks.ps1
```

## 자동 동기화

`.claude`를 원본으로 두고 `.agent`, `.agents`는 미러로 관리되며, **sync 명령을 수동으로 기억할 필요가 없습니다**.

- **Claude Code PostToolUse 훅** (`.claude/settings.json`): Claude Code가 `.claude/` 아래 파일을 수정하면 즉시 sync 스크립트가 실행됩니다.
- **git pre-commit 훅** (`.githooks/pre-commit`): 어떤 에이전트(Claude / Codex / Antigravity)에서 편집했든, `.claude/` 변경을 staged 하면 커밋 직전에 sync가 돌고 미러 변경이 같은 커밋에 포함됩니다. 최초 1회만 `scripts/install-hooks.sh`로 활성화.

수동 실행이 필요하면:

```bash
./scripts/sync-agent-files.sh
```

```powershell
.\scripts\sync-agent-files.ps1
```

## 운영 권장 루프

1. `session-start`로 현재 상태 확인
2. 작업 진행 중 필요하면 `agent-handoff` 또는 `checkpoint` 사용
3. 세션 종료 시 `session-wrap-up`으로 `task.md`, 세션 로그, `docs/lessons.md` 반영 여부 점검

## 3-Agent 동기화 원칙

- **공통 작성**
  - 공통 규칙과 shared skill은 `.claude`에서 작성합니다.
- **실행 미러**
  - `.claude` 내용은 스크립트를 통해 `.agent`, `.agents/skills`로 복사됩니다.
- **Antigravity 호환**
  - `.agent/workflows/`는 `.claude/skills/*/SKILL.md`를 flatten한 호환 미러로 유지합니다.
- **주의**
  - `.agent`, `.agents/skills` 폴더를 직접 수정하면 다음 동기화 시 덮어써질 수 있습니다. 복구 모드 외에는 직접 수정하지 않습니다.

## 주요 파일 설명

- `AGENTS.md`
  - 에이전트가 가장 먼저 읽어야 할 운영 매뉴얼
- `task.md`
  - 현재 진행 중인 작업, 다음 할 일, 완료된 작업을 기록
- `docs/lessons.md`
  - 반복되는 교훈, 운영 개선점, 체크리스트를 누적
- `docs/session-logs/*.md`
  - 세션 로그, handoff, review, status 문서
- `.claude/rules/workflow.md`
  - skill-first 구조 규칙
- `.claude/rules/ai-tools-setup.md`
  - 도구별 역할 구분
- `.claude/rules/sync-rules.md`
  - `.claude -> .agent` 동기화 규칙
