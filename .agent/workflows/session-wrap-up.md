---
description: AI 세션 종료 및 작업 내용 정리 워크플로우
---

# Session Wrap-up Workflow

이 워크플로우는 AI 세션을 종료할 때 작업 내용을 정리하고 다음 세션을 위한 컨텍스트를 저장합니다.

## 1. 세션 로그 생성
- `docs/session-logs/YYYY-MM-DD_[작업요약].md` 형식으로 새 파일 생성
- 오늘 수행한 작업 내용을 요약하여 기록

## 2. task.md 업데이트
- 완료된 Task의 Status를 `Done`으로 변경
- 진행 중인 Task의 현재 상태 기록
- Next Steps 섹션 업데이트

## 3. 세션 로그 내용
```markdown
# 세션 로그 - YYYY-MM-DD

## 수행한 작업
- 작업 1
- 작업 2

## 변경된 파일
- `file1.md`
- `file2.js`

## Next Steps
- [ ] 다음 할 일 1
- [ ] 다음 할 일 2

## 메모
추가 메모 사항
```
