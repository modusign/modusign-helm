# modusign-helm
Modusign helm chart repository

## Add helm repository
```
helm repo add modusign-helm https://modusign.github.io/modusign-helm/
helm repo update
helm search repo modusign-helm
```

## Add/Upgrade helm chart
- `/charts` 하위에 차트 추가/수정
- Chart.yaml 에서 version 정보 수정
- main 을 base로 squash merge

## Test helm chart

차트 템플릿 테스트는 [helm-unittest](https://github.com/helm-unittest/helm-unittest) 로 합니다. 클러스터 없이 렌더링 결과만 검증합니다.

### 설치

```
helm plugin install https://github.com/helm-unittest/helm-unittest
```

### 실행

```
helm unittest -f 'tests/**/*_test.yaml' charts/application-template
helm unittest -f 'tests/**/*_test.yaml' charts/cronjob-template
```

- 테스트는 각 차트의 `tests/` 하위에 `*_test.yaml` 로 둡니다. 컴포넌트가 여러 개인 차트는 `tests/server/`, `tests/worker/` 처럼 나눕니다.
- 기본 glob 은 하위 디렉토리를 훑지 않으므로 `-f 'tests/**/*_test.yaml'` 가 필요합니다. 이걸 빼면 테스트가 0개 발견되고도 통과한 것처럼 보입니다.
- suite 하나만 돌리려면 경로를 직접 넘깁니다.

```
helm unittest -f 'tests/server/external_secret_test.yaml' charts/application-template
```

### 테스트 작성

suite 는 `templates` 로 렌더링할 템플릿을 정하고, `it` 마다 `set` 으로 values 를 덮어쓴 뒤 렌더 결과를 assert 합니다.

```yaml
suite: server - external secret
templates:
  - templates/server/external-secret.yaml

tests:
  - it: enabled=false 이면 렌더링되지 않아야 한다
    asserts:
      - hasDocuments:
          count: 0

  - it: 동기화 대상 Secret 이름에 접미사가 붙어야 한다
    set:
      global.externalSecret.enabled: true
      global.externalSecret.path: stage-default/application/document
    asserts:
      - equal:
          path: spec.target.name
          value: RELEASE-NAME-server-external-secrets
```

자주 걸리는 것들입니다.

- 릴리스 이름 기본값은 `RELEASE-NAME` 입니다. assert 하는 리소스 이름에 그대로 들어갑니다.
- suite 에 템플릿을 여러 개 넣었으면 `it` 마다 `template` 으로 대상을 좁힙니다. 안 그러면 assert 가 모든 문서에 걸립니다.
- 템플릿이 `include (print $.Template.BasePath "/...")` 로 다른 파일을 끌어다 쓰면 그 파일도 `templates` 목록에 넣어야 합니다. 안 넣으면 assert 실패가 아니라 렌더 에러로 죽습니다. `checksum/secret` 어노테이션이 이 경우입니다.
- 컴포넌트 기본값을 확인하고 set 합니다. `worker` 와 `scheduler` 는 `enabled` 가 false 이고 `workload` 가 deployment 입니다. `server` 는 `workload` 가 rollout 입니다.
- 순서가 의미 있는 필드는 `contains` 대신 인덱스로 assert 합니다. `envFrom` 은 뒤쪽 항목이 이기므로 순서가 곧 동작입니다.

## Release helm chart
- release workflow 에 의해 자동화 되어있습니다.
- 이 workflow 는 Chart.yaml에 version 이 수정되었을때 트리거됩니다.
- release 결과는 gh-page가 배포 완료 된 후 사용가능합니다.