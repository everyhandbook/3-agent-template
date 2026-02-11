# 워크플로우 실행 규칙

이 프로젝트는 워크플로우를 두 곳에서 동기화하여 관리합니다:
- `.agent/workflows/` → Antigravity IDE (`/명령어`)
- `.claude/commands/` → Claude Code (`/명령어`)

## 사용 예시

- `/session-start` 또는 "session-start 해줘"
- `/session-wrap-up` 또는 "session-wrap-up 해줘"

## 워크플로우 생성/수정 규칙

사용자가 워크플로우를 생성하거나 수정할 때:

1. **`.claude/commands` 폴더에서만 생성/수정**
   - `.claude/commands/[워크플로우명].md`

2. **동기화 실행**
   - 스크립트를 실행해 `.agent`로 반영합니다.
   
   ⚠️ **경고**: `.agent/workflows`를 직접 수정하지 마세요. 동기화 시 덮어써집니다.

3. 파일 형식 (frontmatter 포함):
   ```markdown
   ---
   description: 워크플로우 설명
   ---

   # 워크플로우 제목

   내용...
   ```

**중요**: 워크플로우 원본은 `.claude/commands`입니다. 수정 후 동기화로 `.agent/workflows`에 반영하세요.
