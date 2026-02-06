---
paths:
  - "**/Chart.yaml"
  - ".github/**/*"
---

# Git Workflow Rules

## Branch Strategy

- `main`: 릴리즈 브랜치 (보호됨)
- Feature/Fix 브랜치에서 작업 후 `main`으로 squash merge

## Commit Message

Conventional Commits 형식 필수:

```
type(scope): subject

[optional body]
```

**타입:**
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `refactor`: 코드 리팩토링
- `docs`: 문서 수정
- `chore`: 빌드, CI 등 기타 작업
- `test`: 테스트 추가/수정

**예시:**
```
feat(application-template): add HPA external metrics support
fix(cronjob-template): correct indentation in values.yaml
refactor(charts): upgrade chart version to 1.8.6
```

## Release Trigger

- `main` 브랜치 push 시 자동 릴리즈
- **IMPORTANT**: `Chart.yaml`의 `version` 변경 필수
- 동일 버전은 `skip_existing: true`로 무시됨

## PR Guidelines

- 단일 차트 변경 권장
- 여러 차트 동시 변경 시 각각 별도 PR
- 릴리즈 노트 자동 생성됨 (`generate-release-notes: true`)
