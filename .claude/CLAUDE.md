# Project Overview

Modusign Helm chart repository - Kubernetes 애플리케이션 배포를 위한 재사용 가능한 Helm 템플릿 차트 모음

# Architecture & Structure (IMPORTANT)

## Project Architecture

**아키텍처 패턴**: Helm Chart Repository (Multi-Chart)

**핵심 차트 관계**:
- `application-template`: 마이크로서비스 배포용 (Server/Worker/Scheduler 컴포넌트)
- `cronjob-template`: 스케줄 기반 배치 작업용
- `custom-resource-template`: 커스텀 Kubernetes 리소스 배포용

## Directory Structure

```
modusign-helm/
├── charts/                          # Helm 차트 디렉토리
│   ├── application-template/        # 메인 애플리케이션 차트
│   │   ├── templates/
│   │   │   ├── hooks/               # Helm lifecycle hooks (Job)
│   │   │   ├── server/              # Server 컴포넌트 리소스
│   │   │   ├── worker/              # Worker 컴포넌트 리소스
│   │   │   └── scheduler/           # Scheduler 컴포넌트 리소스
│   │   ├── Chart.yaml               # 차트 메타데이터
│   │   ├── values.yaml              # 기본 설정값
│   │   └── CONVENTION.md            # 라벨링 컨벤션
│   ├── cronjob-template/            # CronJob 차트
│   └── custom-resource-template/    # 커스텀 리소스 차트
├── .github/
│   ├── workflows/release.yml        # 차트 릴리즈 자동화
│   └── configs/cr.yaml              # chart-releaser 설정
└── .pre-commit-config.yaml          # Pre-commit hooks 설정
```

**주요 컴포넌트 구조 (application-template):**
- `server/`: HTTP 서버 워크로드 (Deployment/Rollout, Service, HPA, Istio 리소스)
- `worker/`: 백그라운드 워커 워크로드
- `scheduler/`: 스케줄러 워크로드
- `hooks/`: Helm lifecycle hooks (pre-install, post-install 등)

# Conventions

## Code Conventions

**Formatting 도구**: EditorConfig
**설정 파일**: `.editorconfig`

- 들여쓰기: 2 spaces (YAML, JSON, Shell)
- Line endings: LF
- 파일 끝: newline 추가
- Trailing whitespace: 제거 (Markdown 제외)

## Commit Conventions

**Convention**: Conventional Commits
- 형식: `type(scope): message`
- 타입: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`
- commitlint: `@commitlint/config-conventional` 사용

## Pre-commit Hooks

**Hook 도구**: pre-commit

커밋 전 자동 실행되는 검사:
- `check-yaml`: YAML 문법 검증 (chart 템플릿 제외)
- `end-of-file-fixer`: 파일 끝 newline 확인
- `trailing-whitespace`: 불필요한 공백 제거
- `check-merge-conflict`: 머지 충돌 마커 확인
- `check-added-large-files`: 5MB 이상 파일 차단
- `shfmt`: Shell 스크립트 포맷팅
- `helmlint`: Helm 차트 린트
- `helm-docs`: README 자동 생성

**IMPORTANT**: 커밋 메시지 검증은 `commit-msg` 스테이지에서 실행됨

# Commands

## Development

- Lint: `helm lint charts/<chart-name>`
- Template: `helm template <release-name> charts/<chart-name> -f values.yaml`
- Dry-run: `helm install --dry-run --debug <release-name> charts/<chart-name>`

## Testing

- Helm lint all: `for d in charts/*/; do helm lint "$d"; done`

## Pre-commit

- Install hooks: `pre-commit install && pre-commit install --hook-type commit-msg`
- Run all hooks: `pre-commit run --all-files`
- Run specific hook: `pre-commit run <hook-id>`

## Helm Docs

- Generate README: `helm-docs --template-files=README.md.gotmpl`

# CI/CD Pipeline

## Workflows

**CI 도구**: GitHub Actions

| Workflow       | 트리거       | 주요 단계                    |
| -------------- | ------------ | ---------------------------- |
| Release Charts | push to main | checkout, helm, chart-releaser |

## Release Strategy

**자동 릴리즈 조건**:
- `main` 브랜치에 push 시 자동 트리거
- `Chart.yaml`의 `version` 변경 시에만 실제 릴리즈 수행
- `helm/chart-releaser-action` 사용

**배포 방식**:
- GitHub Pages (`gh-pages` 브랜치)로 Helm repository 호스팅
- `skip_existing: true`로 중복 릴리즈 방지

# Workflow

## Chart 추가/수정

1. `charts/` 하위에 차트 추가 또는 수정
2. `Chart.yaml`에서 `version` 업데이트
3. `main` 브랜치로 squash merge
4. 릴리즈 workflow 자동 실행

## Chart 사용

```bash
helm repo add modusign-helm https://modusign.github.io/modusign-helm/
helm repo update
helm search repo modusign-helm
```

# Common Gotchas

- **IMPORTANT**: `Chart.yaml`의 `version`을 변경해야만 릴리즈가 수행됨
- Kubernetes 버전 요구사항: `>=1.23`
- 기본 이미지 레지스트리: `harbor.modusign.co.kr/modusign`
- Istio 리소스는 `server.istio.enabled: true`일 때만 생성됨
- ArgoCD Vault Plugin 사용 시 `vault.enabled: true` 설정 필요
