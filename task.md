# 작업 추적

## 현재 단계

**초기화**: 파일 구조 설정 및 기본 환경 구성

## 진행 상황

| 작업 | 상태 | 메모 |
|------|--------|-------|
| 프로젝트 생성 (초기화) | 완료 (Done) | 템플릿 레포 생성 완료 |
| 기본 규칙 설정 (프로젝트별) | 완료 (Done) | 기본 규칙/운영 문서 포함 |
| 최신 3-Agent 구조 반영 | 완료 (Done) | `skills / commands / workflows / sync` 구조 최신화 |
| 공용 3-Agent 기본 세트 보강 | 완료 (Done) | `agent-handoff`, `docs/lessons.md`, 운영 문구 정합성 반영 |

## 상태 범례

- **대기 (Pending)**: 아직 시작 안함
- **진행 중 (In Progress)**: 진행 중
- **완료 (Done)**: 완료
- **차단됨 (Blocked)**: 차단됨 (사유 기록)

## 다음 단계

- [ ] `.claude/rules/project-rules.md`에 실제 프로젝트별 규칙 정의
- [ ] 새 프로젝트에서 `.agents/skills/` 필요 skill 선별
- [ ] 첫 번째 동기화 및 checkpoint workflow 실행 테스트
- [ ] `agent-handoff`로 brief / review / handoff / status 문서 흐름 테스트
- [ ] `docs/lessons.md`를 실제 운영 교훈 누적 문서로 사용 시작
