# 3-Agent 시스템 템플릿

이 레포지토리는 **단일 소스(Single Source)**를 기반으로 다양한 AI 에이전트(Claude Code, Google Antigravity, Codex)가 협업하는 템플릿 프로젝트입니다.

## 핵심 목적

1.  **AI 에이전트 간의 설정 통일**: 하나의 진실(Single Source)을 유지하며 여러 에이전트가 동일한 규칙과 워크플로우를 참조하도록 합니다.
2.  **워크플로우 자동화**: 반복적인 작업(세션 시작/종료 등)을 스크립트와 문서로 자동화합니다.
3.  **문서 기반 운영**: 프로젝트의 모든 상태와 의사결정을 문서(`task.md`, `AGENTS.md`)에 기록하여 히스토리를 관리합니다.

## 디렉토리 구조

```text
.
├── .claude/                    # 규칙/워크플로우의 단일 원본 (Primary)
│   ├── commands/               # 실행 가능한 명령어 모음
│   └── rules/                  # 프로젝트 전반의 규칙 (코딩 스타일 등)
├── .agent/                     # .claude의 읽기 전용 미러 (Mirror)
│   ├── workflows/              # Antigravity/Codex가 참조하는 워크플로우
│   └── rules/                  # Antigravity/Codex가 참조하는 규칙
├── scripts/                    # 동기화 스크립트 (Bash/PowerShell)
├── AGENTS.md                   # 에이전트 운영 가이드
└── task.md                     # 프로젝트 진행 상황 추적
```

## 시작하기

1.  이 템플릿을 복제(Clone)하거나 다운로드하여 새 프로젝트를 시작하세요.
2.  `AGENTS.md`를 프로젝트에 맞게 수정합니다 (옵션).
3.  `.claude/rules/project-rules.md`에 프로젝트별 도메인 규칙이나 비즈니스 로직을 작성합니다.
4.  새로운 워크플로우를 만들고 싶다면 `.claude/commands/`에 마크다운 파일을 생성하세요.
5.  스크립트를 실행하여 `.agent` 폴더로 동기화합니다.

    ```bash
    ./scripts/sync-agent-files.sh
    ```

    또는 Windows:

    ```powershell
    .\scripts\sync-agent-files.ps1
    ```

## 3-Agent 동기화 원칙

- **작성**: 모든 규칙과 명령어는 `.claude` 폴더에서 작성합니다.
- **실행**: `.claude` 내용은 스크립트를 통해 자동으로 `.agent` 폴더로 복사됩니다.
- **주의**: `.agent` 폴더를 직접 수정하면 다음 동기화 시 덮어써지므로 주의하세요. (복구 모드 사용 시 제외)

## 주요 파일 설명

- `AGENTS.md`: 에이전트가 가장 먼저 읽어야 할 운영 매뉴얼
- `task.md`: 현재 진행 중인 작업, 다음 할 일, 완료된 작업을 기록
- `.claude/rules/language.md`: 기본 언어 설정 (한국어 등)
- `.claude/rules/workflow.md`: 워크플로우 작성 규칙
