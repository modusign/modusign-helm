---
paths:
  - "charts/**/*.yaml"
  - "charts/**/*.tpl"
---

# Helm Chart Rules

## Chart Structure

- 각 차트는 `charts/` 디렉토리 하위에 위치
- 필수 파일: `Chart.yaml`, `values.yaml`, `templates/_helpers.tpl`
- README는 `helm-docs`로 자동 생성 (수동 수정 금지)

## Version Management

- **IMPORTANT**: 차트 수정 시 반드시 `Chart.yaml`의 `version` 업데이트
- Semantic Versioning 사용: `MAJOR.MINOR.PATCH`

## Labels Convention

application-template 차트는 다음 라벨 규칙을 따름:

**필수 라벨:**
- `app.kubernetes.io/name`: 워크로드 이름 (e.g., `document-server`)
- `app.kubernetes.io/instance`: Release 이름
- `app.kubernetes.io/version`: 애플리케이션 버전
- `app.kubernetes.io/component`: `server`, `worker`, `scheduler`
- `app.kubernetes.io/part-of`: 최상위 애플리케이션 이름
- `helm.sh/chart`: 차트 정보
- `app.kubernetes.io/managed-by`: `Helm`

**Modusign 커스텀 라벨:**
- `app.modusign.co.kr/zone`: 네임스페이스 기반 zone
- `app.kubernetes.io/env`: 런타임 환경 (`prod`, `stage`, `dev`)

## Template Patterns

- Helper 함수는 `_helpers.tpl`에 정의
- 조건부 리소스 생성: `{{- if .Values.xxx.enabled }}`
- 컴포넌트별 templates: `server/`, `worker/`, `scheduler/` 디렉토리로 분리

## Values Structure

- `global.*`: 모든 컴포넌트 공통 설정
- `server.*`, `worker.*`, `scheduler.*`: 컴포넌트별 설정
- 컴포넌트 설정이 없으면 global 값 사용
