# ExternalSecret 지원 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** OpenBao KV path 하나를 External Secrets Operator로 가져와 pod env로 주입하는 경로를 application-template과 cronjob-template에 추가한다.

**Architecture:** 컴포넌트마다 `ExternalSecret` CR을 렌더링하고 ESO가 이를 `<component>-external-secrets` Secret으로 동기화한다. 워크로드는 그 Secret을 `envFrom.secretRef`로 읽는다. 기존 argocd-vault-plugin 경로는 손대지 않고 `global.externalSecret.enabled`로 독립 토글한다.

**Tech Stack:** Helm 3, helm-unittest 1.0.3, helm-docs, External Secrets Operator (`external-secrets.io/v1`), OpenBao KV

**Spec:** `docs/superpowers/specs/2026-09-09-external-secret-support-design.md`

## Global Constraints

- ExternalSecret apiVersion은 `external-secrets.io/v1` 고정
- ExternalSecret 이름은 컴포넌트 이름 그대로, 동기화 대상 Secret 이름은 `<컴포넌트 이름>-external-secrets`
- `refreshInterval` 기본값은 `3m`
- `secretStoreRef` 기본값은 `kind: ClusterSecretStore`, `name: openbao`. 차트는 SecretStore CR을 생성하지 않는다
- KV는 `dataFrom.extract`로 통째로 가져온다. 키 단위 매핑은 지원하지 않는다
- 컴포넌트별 override는 만들지 않는다. `global.externalSecret` 하나가 릴리스 전체에 적용된다
- hook job(`hook.jobs[]`)은 이번 범위에서 제외
- 테스트 실행 명령은 `helm unittest -f 'tests/**/*_test.yaml' <chart path>`. 기본 패턴은 하위 디렉토리를 훑지 않으므로 `-f`가 필수다
- 커밋 메시지는 한 줄 100자 이내, 본문에 `Ref: [DOS-3091]` 포함
- 브랜치는 `feat/DOS-3091-external-secret-support`, PR base는 `main`

---

## File Structure

**신규**

| 파일 | 책임 |
| --- | --- |
| `charts/application-template/templates/server/external-secret.yaml` | server ExternalSecret CR |
| `charts/application-template/templates/worker/external-secret.yaml` | worker ExternalSecret CR |
| `charts/application-template/templates/scheduler/external-secret.yaml` | scheduler ExternalSecret CR |
| `charts/cronjob-template/templates/external-secret.yaml` | cronjob ExternalSecret CR |
| `charts/application-template/tests/server/external_secret_test.yaml` | server CR 렌더링 검증 |
| `charts/application-template/tests/server/external_secret_envfrom_test.yaml` | server deployment/rollout envFrom 검증 |
| `charts/application-template/tests/worker/external_secret_test.yaml` | worker CR 렌더링 검증 |
| `charts/application-template/tests/worker/external_secret_envfrom_test.yaml` | worker deployment/rollout envFrom 검증 |
| `charts/application-template/tests/scheduler/external_secret_test.yaml` | scheduler CR 렌더링 검증 |
| `charts/application-template/tests/scheduler/external_secret_envfrom_test.yaml` | scheduler deployment/rollout envFrom 검증 |
| `charts/cronjob-template/tests/external_secret_test.yaml` | cronjob CR 렌더링 및 envFrom 검증 |

**수정**

| 파일 | 변경 |
| --- | --- |
| `charts/application-template/values.yaml` | `global.externalSecret` 블록 추가 |
| `charts/application-template/templates/_helpers.tpl` | 컴포넌트별 `externalSecretName` 헬퍼 3개 |
| `charts/application-template/templates/{server,worker,scheduler}/deployment.yaml` | envFrom에 secretRef 추가 |
| `charts/application-template/templates/{server,worker,scheduler}/rollout.yaml` | envFrom에 secretRef 추가 |
| `charts/cronjob-template/values.yaml` | 루트 `externalSecret` 블록 추가 |
| `charts/cronjob-template/templates/_helpers.tpl` | `application.externalSecretName` 헬퍼 |
| `charts/cronjob-template/templates/cron-job.yaml` | envFrom에 secretRef 추가 |
| `charts/application-template/Chart.yaml` | 1.12.2 에서 1.13.0 |
| `charts/cronjob-template/Chart.yaml` | 1.2.0 에서 1.3.0 |
| 두 차트의 `README.md` | helm-docs 재생성 |

---

## Task 1: application-template values와 server ExternalSecret

**Files:**
- Modify: `charts/application-template/values.yaml:119` (`global.vault` 블록 바로 뒤)
- Modify: `charts/application-template/templates/_helpers.tpl:18` (scheduler name 헬퍼 뒤)
- Create: `charts/application-template/templates/server/external-secret.yaml`
- Test: `charts/application-template/tests/server/external_secret_test.yaml`

**Interfaces:**
- Consumes: 기존 헬퍼 `application.server.name`, `application.server.labels`
- Produces: values 경로 `global.externalSecret.{enabled,store.kind,store.name,path,refreshInterval}`, 헬퍼 `application.server.externalSecretName`

- [ ] **Step 1: 실패하는 테스트 작성**

`charts/application-template/tests/server/external_secret_test.yaml` 생성.

```yaml
suite: server - external secret
templates:
  - templates/server/external-secret.yaml

tests:
  - it: global.externalSecret.enabled=false이면 렌더링되지 않아야 한다
    asserts:
      - hasDocuments:
          count: 0

  - it: server.enabled=false이면 렌더링되지 않아야 한다
    set:
      server.enabled: false
      global.externalSecret.enabled: true
    asserts:
      - hasDocuments:
          count: 0

  - it: enabled=true이면 ExternalSecret이 렌더링되어야 한다
    set:
      global.externalSecret.enabled: true
    asserts:
      - hasDocuments:
          count: 1
      - isAPIVersion:
          of: external-secrets.io/v1
      - isKind:
          of: ExternalSecret
      - equal:
          path: metadata.name
          value: RELEASE-NAME-server

  - it: 동기화 대상 Secret 이름에 -external-secrets 접미사가 붙어야 한다
    set:
      global.externalSecret.enabled: true
    asserts:
      - equal:
          path: spec.target.name
          value: RELEASE-NAME-server-external-secrets
      - equal:
          path: spec.target.creationPolicy
          value: Owner

  - it: secretStoreRef 기본값이 ClusterSecretStore openbao여야 한다
    set:
      global.externalSecret.enabled: true
    asserts:
      - equal:
          path: spec.secretStoreRef.kind
          value: ClusterSecretStore
      - equal:
          path: spec.secretStoreRef.name
          value: openbao

  - it: secretStoreRef override가 반영되어야 한다
    set:
      global.externalSecret.enabled: true
      global.externalSecret.store.kind: SecretStore
      global.externalSecret.store.name: openbao-dev
    asserts:
      - equal:
          path: spec.secretStoreRef.kind
          value: SecretStore
      - equal:
          path: spec.secretStoreRef.name
          value: openbao-dev

  - it: dataFrom.extract.key가 KV path여야 한다
    set:
      global.externalSecret.enabled: true
      global.externalSecret.path: stage-default/application/document
    asserts:
      - equal:
          path: spec.dataFrom[0].extract.key
          value: stage-default/application/document

  - it: refreshInterval 기본값이 3m이어야 한다
    set:
      global.externalSecret.enabled: true
    asserts:
      - equal:
          path: spec.refreshInterval
          value: 3m

  - it: refreshInterval override가 반영되어야 한다
    set:
      global.externalSecret.enabled: true
      global.externalSecret.refreshInterval: 30s
    asserts:
      - equal:
          path: spec.refreshInterval
          value: 30s

  - it: 컴포넌트 라벨이 붙어야 한다
    set:
      global.externalSecret.enabled: true
    asserts:
      - equal:
          path: metadata.labels["app.kubernetes.io/component"]
          value: server
```

- [ ] **Step 2: 테스트가 실패하는지 확인**

Run: `helm unittest -f 'tests/server/external_secret_test.yaml' charts/application-template`
Expected: FAIL. 템플릿 파일이 없어서 suite가 로드되지 않는다.

- [ ] **Step 3: values.yaml에 global.externalSecret 추가**

`charts/application-template/values.yaml`의 `global.vault` 블록(`secrets: {}` 줄) 바로 뒤, `observability:` 앞에 삽입한다.

```yaml
  # -- OpenBao KV secret을 External Secrets Operator로 가져와 env로 주입한다
  externalSecret:
    enabled: false
    # -- 인프라 레포에서 관리하는 SecretStore 참조. 차트는 SecretStore CR을 만들지 않는다
    store:
      kind: ClusterSecretStore
      name: openbao
    # -- OpenBao KV path. 이 path의 모든 키가 그대로 env 이름이 된다
    path: stage-default/application/${service}
    # -- ESO가 OpenBao를 다시 읽는 주기. secret이 갱신돼도 pod은 자동 재시작되지 않으므로 재시작이 필요하면 podAnnotations에 reloader 어노테이션을 추가한다
    refreshInterval: 3m
```

- [ ] **Step 4: _helpers.tpl에 server 헬퍼 추가**

`charts/application-template/templates/_helpers.tpl`의 `application.scheduler.name` define 뒤(18번째 줄 다음)에 삽입한다.

```
{{/*
ExternalSecret이 동기화하는 Secret 이름
*/}}
{{- define "application.server.externalSecretName" -}}
{{- printf "%s-external-secrets" (include "application.server.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
```

- [ ] **Step 5: server ExternalSecret 템플릿 생성**

`charts/application-template/templates/server/external-secret.yaml` 생성.

```
{{- if .Values.server.enabled }}
{{- if .Values.global.externalSecret.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "application.server.name" . }}
  labels:
    {{- include "application.server.labels" . | nindent 4 }}
spec:
  refreshInterval: {{ .Values.global.externalSecret.refreshInterval }}
  secretStoreRef:
    kind: {{ .Values.global.externalSecret.store.kind }}
    name: {{ .Values.global.externalSecret.store.name }}
  target:
    name: {{ include "application.server.externalSecretName" . }}
    creationPolicy: Owner
  dataFrom:
    - extract:
        key: {{ .Values.global.externalSecret.path }}
{{- end }}
{{- end }}
```

- [ ] **Step 6: 테스트가 통과하는지 확인**

Run: `helm unittest -f 'tests/**/*_test.yaml' charts/application-template`
Expected: PASS. 기존 hooks suite 3개와 신규 suite 1개가 모두 통과한다.

- [ ] **Step 7: 커밋**

```bash
git add charts/application-template/values.yaml \
  charts/application-template/templates/_helpers.tpl \
  charts/application-template/templates/server/external-secret.yaml \
  charts/application-template/tests/server/external_secret_test.yaml
git commit -m "feat(application-template): server ExternalSecret 리소스 추가

OpenBao KV path를 dataFrom.extract로 통째로 가져오는 ExternalSecret을
global.externalSecret.enabled로 렌더링한다.

Ref: [DOS-3091]"
```

---

## Task 2: server 워크로드 envFrom 주입

**Files:**
- Modify: `charts/application-template/templates/server/deployment.yaml:103-106`
- Modify: `charts/application-template/templates/server/rollout.yaml:107-110`
- Test: `charts/application-template/tests/server/external_secret_envfrom_test.yaml`

**Interfaces:**
- Consumes: Task 1의 헬퍼 `application.server.externalSecretName`, values `global.externalSecret.enabled`
- Produces: 컨테이너 `envFrom`에 `secretRef.name: <server name>-external-secrets` 항목

- [ ] **Step 1: 실패하는 테스트 작성**

`charts/application-template/tests/server/external_secret_envfrom_test.yaml` 생성. `server.workload` 기본값은 `rollout`이지만 테스트에서는 항상 명시한다.

```yaml
suite: server - external secret envFrom
templates:
  - templates/server/deployment.yaml
  - templates/server/rollout.yaml

tests:
  - it: rollout envFrom에 externalSecret secretRef가 주입되어야 한다
    template: templates/server/rollout.yaml
    set:
      server.workload: rollout
      global.externalSecret.enabled: true
    asserts:
      - contains:
          path: spec.template.spec.containers[0].envFrom
          content:
            secretRef:
              name: RELEASE-NAME-server-external-secrets

  - it: deployment envFrom에 externalSecret secretRef가 주입되어야 한다
    template: templates/server/deployment.yaml
    set:
      server.workload: deployment
      global.externalSecret.enabled: true
    asserts:
      - contains:
          path: spec.template.spec.containers[0].envFrom
          content:
            secretRef:
              name: RELEASE-NAME-server-external-secrets

  - it: avp와 동시에 켜면 externalSecret secretRef가 avp 뒤에 와야 한다
    template: templates/server/rollout.yaml
    set:
      server.workload: rollout
      global.vault.enabled: true
      global.externalSecret.enabled: true
    asserts:
      - equal:
          path: spec.template.spec.containers[0].envFrom[0].secretRef.name
          value: RELEASE-NAME-server
      - equal:
          path: spec.template.spec.containers[0].envFrom[1].secretRef.name
          value: RELEASE-NAME-server-external-secrets

  - it: externalSecret이 꺼져 있으면 avp secretRef만 있어야 한다
    template: templates/server/rollout.yaml
    set:
      server.workload: rollout
      global.vault.enabled: true
    asserts:
      - lengthEqual:
          path: spec.template.spec.containers[0].envFrom
          count: 1
      - equal:
          path: spec.template.spec.containers[0].envFrom[0].secretRef.name
          value: RELEASE-NAME-server
```

- [ ] **Step 2: 테스트가 실패하는지 확인**

Run: `helm unittest -f 'tests/server/external_secret_envfrom_test.yaml' charts/application-template`
Expected: FAIL. 첫 3개 테스트가 secretRef를 찾지 못한다.

- [ ] **Step 3: deployment.yaml 수정**

`charts/application-template/templates/server/deployment.yaml`의 avp 블록 뒤, `.Values.server.envFrom` 앞에 삽입한다. 삽입 전 모습은 이렇다.

```
        {{- if .Values.global.vault.enabled  }}
          - secretRef:
              name: {{ include "application.name" . }}
        {{- end }}
        {{- with .Values.server.envFrom }}
```

삽입 후 모습은 이렇다.

```
        {{- if .Values.global.vault.enabled  }}
          - secretRef:
              name: {{ include "application.name" . }}
        {{- end }}
        {{- if .Values.global.externalSecret.enabled }}
          - secretRef:
              name: {{ include "application.server.externalSecretName" . }}
        {{- end }}
        {{- with .Values.server.envFrom }}
```

- [ ] **Step 4: rollout.yaml 수정**

`charts/application-template/templates/server/rollout.yaml`에 Step 3과 완전히 동일한 4줄을 같은 위치(avp 블록 `{{- end }}` 다음)에 삽입한다.

```
        {{- if .Values.global.externalSecret.enabled }}
          - secretRef:
              name: {{ include "application.server.externalSecretName" . }}
        {{- end }}
```

- [ ] **Step 5: 테스트가 통과하는지 확인**

Run: `helm unittest -f 'tests/**/*_test.yaml' charts/application-template`
Expected: PASS

- [ ] **Step 6: 커밋**

```bash
git add charts/application-template/templates/server/deployment.yaml \
  charts/application-template/templates/server/rollout.yaml \
  charts/application-template/tests/server/external_secret_envfrom_test.yaml
git commit -m "feat(application-template): server envFrom에 ExternalSecret 주입

동기화된 Secret을 avp Secret 뒤에 붙여 키가 겹칠 때 ESO 값이 이기게 한다.

Ref: [DOS-3091]"
```

---

## Task 3: worker ExternalSecret과 envFrom

**Files:**
- Modify: `charts/application-template/templates/_helpers.tpl` (Task 1에서 추가한 server 헬퍼 뒤)
- Create: `charts/application-template/templates/worker/external-secret.yaml`
- Modify: `charts/application-template/templates/worker/deployment.yaml:103-106`
- Modify: `charts/application-template/templates/worker/rollout.yaml:107-110`
- Test: `charts/application-template/tests/worker/external_secret_test.yaml`
- Test: `charts/application-template/tests/worker/external_secret_envfrom_test.yaml`

**Interfaces:**
- Consumes: values `global.externalSecret.*` (Task 1), 헬퍼 `application.worker.name`, `application.worker.labels`
- Produces: 헬퍼 `application.worker.externalSecretName`

`worker.enabled` 기본값이 `false`라 모든 worker 테스트는 `worker.enabled: true`를 함께 set 해야 한다. `worker.workload` 기본값은 server와 달리 `deployment`이므로 rollout을 검증할 때는 반드시 명시한다.

- [ ] **Step 1: 실패하는 테스트 작성**

`charts/application-template/tests/worker/external_secret_test.yaml` 생성.

```yaml
suite: worker - external secret
templates:
  - templates/worker/external-secret.yaml

tests:
  - it: global.externalSecret.enabled=false이면 렌더링되지 않아야 한다
    set:
      worker.enabled: true
    asserts:
      - hasDocuments:
          count: 0

  - it: worker.enabled=false이면 렌더링되지 않아야 한다
    set:
      global.externalSecret.enabled: true
    asserts:
      - hasDocuments:
          count: 0

  - it: enabled=true이면 ExternalSecret이 렌더링되어야 한다
    set:
      worker.enabled: true
      global.externalSecret.enabled: true
    asserts:
      - hasDocuments:
          count: 1
      - isAPIVersion:
          of: external-secrets.io/v1
      - isKind:
          of: ExternalSecret
      - equal:
          path: metadata.name
          value: RELEASE-NAME-worker
      - equal:
          path: spec.target.name
          value: RELEASE-NAME-worker-external-secrets
      - equal:
          path: spec.target.creationPolicy
          value: Owner

  - it: secretStoreRef와 dataFrom이 values를 따라야 한다
    set:
      worker.enabled: true
      global.externalSecret.enabled: true
      global.externalSecret.path: stage-default/application/document
    asserts:
      - equal:
          path: spec.secretStoreRef.kind
          value: ClusterSecretStore
      - equal:
          path: spec.secretStoreRef.name
          value: openbao
      - equal:
          path: spec.dataFrom[0].extract.key
          value: stage-default/application/document
      - equal:
          path: spec.refreshInterval
          value: 3m

  - it: 컴포넌트 라벨이 붙어야 한다
    set:
      worker.enabled: true
      global.externalSecret.enabled: true
    asserts:
      - equal:
          path: metadata.labels["app.kubernetes.io/component"]
          value: worker
```

`charts/application-template/tests/worker/external_secret_envfrom_test.yaml` 생성.

```yaml
suite: worker - external secret envFrom
templates:
  - templates/worker/deployment.yaml
  - templates/worker/rollout.yaml

tests:
  - it: rollout envFrom에 externalSecret secretRef가 주입되어야 한다
    template: templates/worker/rollout.yaml
    set:
      worker.enabled: true
      worker.workload: rollout
      global.externalSecret.enabled: true
    asserts:
      - contains:
          path: spec.template.spec.containers[0].envFrom
          content:
            secretRef:
              name: RELEASE-NAME-worker-external-secrets

  - it: deployment envFrom에 externalSecret secretRef가 주입되어야 한다
    template: templates/worker/deployment.yaml
    set:
      worker.enabled: true
      worker.workload: deployment
      global.externalSecret.enabled: true
    asserts:
      - contains:
          path: spec.template.spec.containers[0].envFrom
          content:
            secretRef:
              name: RELEASE-NAME-worker-external-secrets

  - it: avp와 동시에 켜면 externalSecret secretRef가 avp 뒤에 와야 한다
    template: templates/worker/rollout.yaml
    set:
      worker.enabled: true
      worker.workload: rollout
      global.vault.enabled: true
      global.externalSecret.enabled: true
    asserts:
      - equal:
          path: spec.template.spec.containers[0].envFrom[0].secretRef.name
          value: RELEASE-NAME-worker
      - equal:
          path: spec.template.spec.containers[0].envFrom[1].secretRef.name
          value: RELEASE-NAME-worker-external-secrets
```

- [ ] **Step 2: 테스트가 실패하는지 확인**

Run: `helm unittest -f 'tests/worker/*_test.yaml' charts/application-template`
Expected: FAIL

- [ ] **Step 3: _helpers.tpl에 worker 헬퍼 추가**

Task 1에서 추가한 `application.server.externalSecretName` 바로 뒤에 삽입한다.

```
{{- define "application.worker.externalSecretName" -}}
{{- printf "%s-external-secrets" (include "application.worker.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
```

- [ ] **Step 4: worker ExternalSecret 템플릿 생성**

`charts/application-template/templates/worker/external-secret.yaml` 생성.

```
{{- if .Values.worker.enabled }}
{{- if .Values.global.externalSecret.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "application.worker.name" . }}
  labels:
    {{- include "application.worker.labels" . | nindent 4 }}
spec:
  refreshInterval: {{ .Values.global.externalSecret.refreshInterval }}
  secretStoreRef:
    kind: {{ .Values.global.externalSecret.store.kind }}
    name: {{ .Values.global.externalSecret.store.name }}
  target:
    name: {{ include "application.worker.externalSecretName" . }}
    creationPolicy: Owner
  dataFrom:
    - extract:
        key: {{ .Values.global.externalSecret.path }}
{{- end }}
{{- end }}
```

- [ ] **Step 5: worker deployment.yaml과 rollout.yaml 수정**

두 파일 모두 avp 블록(`{{- if .Values.global.vault.enabled  }}` ... `{{- end }}`) 바로 뒤에 아래 4줄을 삽입한다.

```
        {{- if .Values.global.externalSecret.enabled }}
          - secretRef:
              name: {{ include "application.worker.externalSecretName" . }}
        {{- end }}
```

- [ ] **Step 6: 테스트가 통과하는지 확인**

Run: `helm unittest -f 'tests/**/*_test.yaml' charts/application-template`
Expected: PASS

- [ ] **Step 7: 커밋**

```bash
git add charts/application-template/templates/_helpers.tpl \
  charts/application-template/templates/worker/external-secret.yaml \
  charts/application-template/templates/worker/deployment.yaml \
  charts/application-template/templates/worker/rollout.yaml \
  charts/application-template/tests/worker
git commit -m "feat(application-template): worker ExternalSecret 지원 추가

Ref: [DOS-3091]"
```

---

## Task 4: scheduler ExternalSecret과 envFrom

**Files:**
- Modify: `charts/application-template/templates/_helpers.tpl` (Task 3에서 추가한 worker 헬퍼 뒤)
- Create: `charts/application-template/templates/scheduler/external-secret.yaml`
- Modify: `charts/application-template/templates/scheduler/deployment.yaml:103-106`
- Modify: `charts/application-template/templates/scheduler/rollout.yaml:107-110`
- Test: `charts/application-template/tests/scheduler/external_secret_test.yaml`
- Test: `charts/application-template/tests/scheduler/external_secret_envfrom_test.yaml`

**Interfaces:**
- Consumes: values `global.externalSecret.*` (Task 1), 헬퍼 `application.scheduler.name`, `application.scheduler.labels`
- Produces: 헬퍼 `application.scheduler.externalSecretName`

`scheduler.enabled` 기본값도 `false`다. `scheduler.workload` 기본값은 `deployment`이므로 rollout을 검증할 때는 반드시 명시한다.

- [ ] **Step 1: 실패하는 테스트 작성**

`charts/application-template/tests/scheduler/external_secret_test.yaml` 생성.

```yaml
suite: scheduler - external secret
templates:
  - templates/scheduler/external-secret.yaml

tests:
  - it: global.externalSecret.enabled=false이면 렌더링되지 않아야 한다
    set:
      scheduler.enabled: true
    asserts:
      - hasDocuments:
          count: 0

  - it: scheduler.enabled=false이면 렌더링되지 않아야 한다
    set:
      global.externalSecret.enabled: true
    asserts:
      - hasDocuments:
          count: 0

  - it: enabled=true이면 ExternalSecret이 렌더링되어야 한다
    set:
      scheduler.enabled: true
      global.externalSecret.enabled: true
    asserts:
      - hasDocuments:
          count: 1
      - isAPIVersion:
          of: external-secrets.io/v1
      - isKind:
          of: ExternalSecret
      - equal:
          path: metadata.name
          value: RELEASE-NAME-scheduler
      - equal:
          path: spec.target.name
          value: RELEASE-NAME-scheduler-external-secrets
      - equal:
          path: spec.target.creationPolicy
          value: Owner

  - it: secretStoreRef와 dataFrom이 values를 따라야 한다
    set:
      scheduler.enabled: true
      global.externalSecret.enabled: true
      global.externalSecret.path: stage-default/application/document
    asserts:
      - equal:
          path: spec.secretStoreRef.kind
          value: ClusterSecretStore
      - equal:
          path: spec.secretStoreRef.name
          value: openbao
      - equal:
          path: spec.dataFrom[0].extract.key
          value: stage-default/application/document
      - equal:
          path: spec.refreshInterval
          value: 3m

  - it: 컴포넌트 라벨이 붙어야 한다
    set:
      scheduler.enabled: true
      global.externalSecret.enabled: true
    asserts:
      - equal:
          path: metadata.labels["app.kubernetes.io/component"]
          value: scheduler
```

`charts/application-template/tests/scheduler/external_secret_envfrom_test.yaml` 생성.

```yaml
suite: scheduler - external secret envFrom
templates:
  - templates/scheduler/deployment.yaml
  - templates/scheduler/rollout.yaml

tests:
  - it: rollout envFrom에 externalSecret secretRef가 주입되어야 한다
    template: templates/scheduler/rollout.yaml
    set:
      scheduler.enabled: true
      scheduler.workload: rollout
      global.externalSecret.enabled: true
    asserts:
      - contains:
          path: spec.template.spec.containers[0].envFrom
          content:
            secretRef:
              name: RELEASE-NAME-scheduler-external-secrets

  - it: deployment envFrom에 externalSecret secretRef가 주입되어야 한다
    template: templates/scheduler/deployment.yaml
    set:
      scheduler.enabled: true
      scheduler.workload: deployment
      global.externalSecret.enabled: true
    asserts:
      - contains:
          path: spec.template.spec.containers[0].envFrom
          content:
            secretRef:
              name: RELEASE-NAME-scheduler-external-secrets

  - it: avp와 동시에 켜면 externalSecret secretRef가 avp 뒤에 와야 한다
    template: templates/scheduler/rollout.yaml
    set:
      scheduler.enabled: true
      scheduler.workload: rollout
      global.vault.enabled: true
      global.externalSecret.enabled: true
    asserts:
      - equal:
          path: spec.template.spec.containers[0].envFrom[0].secretRef.name
          value: RELEASE-NAME-scheduler
      - equal:
          path: spec.template.spec.containers[0].envFrom[1].secretRef.name
          value: RELEASE-NAME-scheduler-external-secrets
```

- [ ] **Step 2: 테스트가 실패하는지 확인**

Run: `helm unittest -f 'tests/scheduler/*_test.yaml' charts/application-template`
Expected: FAIL

- [ ] **Step 3: _helpers.tpl에 scheduler 헬퍼 추가**

```
{{- define "application.scheduler.externalSecretName" -}}
{{- printf "%s-external-secrets" (include "application.scheduler.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
```

- [ ] **Step 4: scheduler ExternalSecret 템플릿 생성**

`charts/application-template/templates/scheduler/external-secret.yaml` 생성.

```
{{- if .Values.scheduler.enabled }}
{{- if .Values.global.externalSecret.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "application.scheduler.name" . }}
  labels:
    {{- include "application.scheduler.labels" . | nindent 4 }}
spec:
  refreshInterval: {{ .Values.global.externalSecret.refreshInterval }}
  secretStoreRef:
    kind: {{ .Values.global.externalSecret.store.kind }}
    name: {{ .Values.global.externalSecret.store.name }}
  target:
    name: {{ include "application.scheduler.externalSecretName" . }}
    creationPolicy: Owner
  dataFrom:
    - extract:
        key: {{ .Values.global.externalSecret.path }}
{{- end }}
{{- end }}
```

- [ ] **Step 5: scheduler deployment.yaml과 rollout.yaml 수정**

두 파일 모두 avp 블록 바로 뒤에 아래 4줄을 삽입한다.

```
        {{- if .Values.global.externalSecret.enabled }}
          - secretRef:
              name: {{ include "application.scheduler.externalSecretName" . }}
        {{- end }}
```

- [ ] **Step 6: 테스트가 통과하는지 확인**

Run: `helm unittest -f 'tests/**/*_test.yaml' charts/application-template`
Expected: PASS

- [ ] **Step 7: 커밋**

```bash
git add charts/application-template/templates/_helpers.tpl \
  charts/application-template/templates/scheduler/external-secret.yaml \
  charts/application-template/templates/scheduler/deployment.yaml \
  charts/application-template/templates/scheduler/rollout.yaml \
  charts/application-template/tests/scheduler
git commit -m "feat(application-template): scheduler ExternalSecret 지원 추가

Ref: [DOS-3091]"
```

---

## Task 5: cronjob-template ExternalSecret

**Files:**
- Modify: `charts/cronjob-template/values.yaml:205` (루트 `vault` 블록 뒤)
- Modify: `charts/cronjob-template/templates/_helpers.tpl:6` (`application.name` define 뒤)
- Create: `charts/cronjob-template/templates/external-secret.yaml`
- Modify: `charts/cronjob-template/templates/cron-job.yaml:87-90`
- Test: `charts/cronjob-template/tests/external_secret_test.yaml`

**Interfaces:**
- Consumes: 헬퍼 `application.name`, `application.cronJob.labels`
- Produces: values 경로 `externalSecret.{enabled,store.kind,store.name,path,refreshInterval}`, 헬퍼 `application.externalSecretName`

이 차트는 `global`이 아니라 values 루트에 설정을 둔다. 기존 `vault` 블록과 같은 위치다. 릴리스 기본 이름은 `values.yaml`의 `name: cronjob-template` 때문에 `cronjob-template`이다.

- [ ] **Step 1: 실패하는 테스트 작성**

`charts/cronjob-template/tests/external_secret_test.yaml` 생성. 이 차트에는 `tests` 디렉토리가 없으므로 새로 만든다.

```yaml
suite: cronjob - external secret
templates:
  - templates/external-secret.yaml
  - templates/cron-job.yaml

tests:
  - it: externalSecret.enabled=false이면 렌더링되지 않아야 한다
    template: templates/external-secret.yaml
    asserts:
      - hasDocuments:
          count: 0

  - it: enabled=true이면 ExternalSecret이 렌더링되어야 한다
    template: templates/external-secret.yaml
    set:
      externalSecret.enabled: true
    asserts:
      - hasDocuments:
          count: 1
      - isAPIVersion:
          of: external-secrets.io/v1
      - isKind:
          of: ExternalSecret
      - equal:
          path: metadata.name
          value: cronjob-template
      - equal:
          path: spec.target.name
          value: cronjob-template-external-secrets
      - equal:
          path: spec.target.creationPolicy
          value: Owner

  - it: secretStoreRef와 dataFrom이 values를 따라야 한다
    template: templates/external-secret.yaml
    set:
      externalSecret.enabled: true
      externalSecret.path: stage-default/application/batch
    asserts:
      - equal:
          path: spec.secretStoreRef.kind
          value: ClusterSecretStore
      - equal:
          path: spec.secretStoreRef.name
          value: openbao
      - equal:
          path: spec.dataFrom[0].extract.key
          value: stage-default/application/batch
      - equal:
          path: spec.refreshInterval
          value: 3m

  - it: cronjob envFrom에 externalSecret secretRef가 주입되어야 한다
    template: templates/cron-job.yaml
    set:
      externalSecret.enabled: true
    asserts:
      - contains:
          path: spec.jobTemplate.spec.template.spec.containers[0].envFrom
          content:
            secretRef:
              name: cronjob-template-external-secrets

  - it: avp와 동시에 켜면 externalSecret secretRef가 avp 뒤에 와야 한다
    template: templates/cron-job.yaml
    set:
      vault.enabled: true
      externalSecret.enabled: true
    asserts:
      - equal:
          path: spec.jobTemplate.spec.template.spec.containers[0].envFrom[0].secretRef.name
          value: cronjob-template
      - equal:
          path: spec.jobTemplate.spec.template.spec.containers[0].envFrom[1].secretRef.name
          value: cronjob-template-external-secrets
```

- [ ] **Step 2: 테스트가 실패하는지 확인**

Run: `helm unittest -f 'tests/**/*_test.yaml' charts/cronjob-template`
Expected: FAIL

- [ ] **Step 3: values.yaml에 externalSecret 추가**

`charts/cronjob-template/values.yaml`의 `vault` 블록(`secrets: {}` 줄) 바로 뒤에 삽입한다. 들여쓰기가 없는 루트 레벨이다.

```yaml
# -- OpenBao KV secret을 External Secrets Operator로 가져와 env로 주입한다
externalSecret:
  enabled: false
  # -- 인프라 레포에서 관리하는 SecretStore 참조. 차트는 SecretStore CR을 만들지 않는다
  store:
    kind: ClusterSecretStore
    name: openbao
  # -- OpenBao KV path. 이 path의 모든 키가 그대로 env 이름이 된다
  path: stage-default/application/${service}
  # -- ESO가 OpenBao를 다시 읽는 주기. secret이 갱신돼도 pod은 자동 재시작되지 않는다
  refreshInterval: 3m
```

- [ ] **Step 4: _helpers.tpl에 헬퍼 추가**

`charts/cronjob-template/templates/_helpers.tpl`의 `application.name` define 뒤에 삽입한다.

```
{{/*
ExternalSecret이 동기화하는 Secret 이름
*/}}
{{- define "application.externalSecretName" -}}
{{- printf "%s-external-secrets" (include "application.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
```

- [ ] **Step 5: ExternalSecret 템플릿 생성**

`charts/cronjob-template/templates/external-secret.yaml` 생성.

```
{{- if .Values.externalSecret.enabled }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "application.name" . }}
  labels:
    {{- include "application.cronJob.labels" . | nindent 4 }}
spec:
  refreshInterval: {{ .Values.externalSecret.refreshInterval }}
  secretStoreRef:
    kind: {{ .Values.externalSecret.store.kind }}
    name: {{ .Values.externalSecret.store.name }}
  target:
    name: {{ include "application.externalSecretName" . }}
    creationPolicy: Owner
  dataFrom:
    - extract:
        key: {{ .Values.externalSecret.path }}
{{- end }}
```

- [ ] **Step 6: cron-job.yaml 수정**

avp 블록 뒤, `.Values.envFrom` 앞에 삽입한다. 이 파일은 들여쓰기가 4칸 더 깊다.

```
            {{- if .Values.vault.enabled  }}
              - secretRef:
                  name: {{ include "application.name" . }}
            {{- end }}
            {{- if .Values.externalSecret.enabled }}
              - secretRef:
                  name: {{ include "application.externalSecretName" . }}
            {{- end }}
            {{- with .Values.envFrom }}
```

- [ ] **Step 7: 테스트가 통과하는지 확인**

Run: `helm unittest -f 'tests/**/*_test.yaml' charts/cronjob-template`
Expected: PASS

- [ ] **Step 8: 커밋**

```bash
git add charts/cronjob-template/values.yaml \
  charts/cronjob-template/templates/_helpers.tpl \
  charts/cronjob-template/templates/external-secret.yaml \
  charts/cronjob-template/templates/cron-job.yaml \
  charts/cronjob-template/tests
git commit -m "feat(cronjob-template): ExternalSecret 지원 추가

Ref: [DOS-3091]"
```

---

## Task 6: 차트 버전 bump와 README 갱신

**Files:**
- Modify: `charts/application-template/Chart.yaml:11`
- Modify: `charts/cronjob-template/Chart.yaml:11`
- Modify: `charts/application-template/README.md`
- Modify: `charts/cronjob-template/README.md`

**Interfaces:**
- Consumes: Task 1과 Task 5에서 추가한 values 주석
- Produces: 릴리스 가능한 차트 버전

- [ ] **Step 1: Chart.yaml 버전 올리기**

`charts/application-template/Chart.yaml`의 `version: 1.12.2`를 `version: 1.13.0`으로 바꾼다.
`charts/cronjob-template/Chart.yaml`의 `version: 1.2.0`을 `version: 1.3.0`으로 바꾼다.

- [ ] **Step 2: README 재생성**

두 차트만 대상으로 돌린다. 인자 없이 돌리면 `custom-resource-template`에 없던 README까지 새로 만들어지므로 `-g`로 범위를 좁힌다.

```bash
helm-docs -g charts/application-template --template-files=README.md.gotmpl
helm-docs -g charts/cronjob-template --template-files=README.md.gotmpl
```

- [ ] **Step 3: 의도한 파일만 바뀌었는지 확인**

Run: `git status --porcelain`
Expected: `charts/application-template/{Chart.yaml,README.md}`와 `charts/cronjob-template/{Chart.yaml,README.md}` 4개만 수정됨. `charts/custom-resource-template/README.md`가 새로 생겼다면 지운다.

- [ ] **Step 4: 전체 검증**

```bash
helm lint charts/application-template
helm lint charts/cronjob-template
helm unittest -f 'tests/**/*_test.yaml' charts/application-template
helm unittest -f 'tests/**/*_test.yaml' charts/cronjob-template
helm template rel charts/application-template --set global.externalSecret.enabled=true --set worker.enabled=true --set scheduler.enabled=true | grep -c "kind: ExternalSecret"
helm template rel charts/cronjob-template --set externalSecret.enabled=true | grep -c "kind: ExternalSecret"
```

Expected: lint 통과, 두 차트 테스트 모두 PASS, application-template에서 `3`, cronjob-template에서 `1`

- [ ] **Step 5: 커밋**

```bash
git add charts/application-template/Chart.yaml charts/application-template/README.md \
  charts/cronjob-template/Chart.yaml charts/cronjob-template/README.md
git commit -m "chore: ExternalSecret 지원 반영해 차트 버전 및 README 갱신

Ref: [DOS-3091]"
```

- [ ] **Step 6: push와 PR 생성**

```bash
git push -u origin feat/DOS-3091-external-secret-support
gh pr create --base main --assignee atobaum --title "OpenBao ExternalSecret 기반 secret env 주입 지원 추가"
```

PR 본문은 합쇼체로 작성하고 다음을 담는다. 배경(avp의 반영 지연과 셀프 서비스 한계), 변경 내용(`global.externalSecret` 신설, 컴포넌트별 ExternalSecret과 envFrom 주입, cronjob-template 동일 적용), 사용법 예시, 알려진 제약(pod 자동 재시작 없음), `Ref: [DOS-3091]`.
