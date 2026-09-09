# ExternalSecret 지원 설계

Ref: [DOS-3091]

## 배경

현재 secret env는 argocd-vault-plugin(avp)으로 주입한다. 차트가 `avp.kubernetes.io/path` 어노테이션과 placeholder `stringData`를 담은 `Secret`을 렌더링하면 ArgoCD가 배포 시점에 값을 치환하고, 워크로드는 `envFrom.secretRef`로 그 Secret을 읽는다.

이 방식은 값 갱신이 ArgoCD sync 시점에만 일어나고, secret 하나 추가할 때마다 차트 values PR이 필요하다. DOS-3091의 셀프 서비스 요구사항(audit log, version control, 세밀한 권한, 백업/복구, 수동 반영)을 충족하려면 External Secrets Operator(ESO)가 외부 저장소의 secret을 Kubernetes Secret으로 동기화하는 경로가 필요하다.

## 목표

ESO가 참조하는 KV path 하나를 통째로 가져와 pod env로 주입하는 경로를 차트에 추가한다. 기존 avp 경로는 그대로 두고 레포별로 점진 전환할 수 있게 한다.

차트는 어떤 저장소를 쓰는지 알지 않는다. SecretStore를 이름으로 참조할 뿐이고, 저장소 종류와 인증은 그 CR을 만드는 인프라 레포가 정한다.

## 범위

포함

- application-template의 server, worker, scheduler
- cronjob-template

제외

- hook job (`hook.jobs[].vault` 대응). ESO 동기화가 비동기라 hook 타이밍을 따로 검토해야 해서 별도 작업으로 뺀다
- SecretStore / ClusterSecretStore CR 생성. 인프라 레포 책임으로 둔다
- avp 경로 제거. 전환이 끝난 뒤 별도 작업으로 뺀다

## values API

application-template `values.yaml`의 `global` 하위에 신설한다.

```yaml
global:
  externalSecret:
    enabled: false
    store:
      kind: ClusterSecretStore
      name: openbao
    path: stage-default/application/${service}
    refreshInterval: 3m
    annotations: {}
```

`refreshInterval` 기본값 3m은 ArgoCD와 무관하게 정한 값이다. ESO는 ArgoCD sync와 상관없이 자체 주기로 저장소를 읽는다. 기존 avp는 repo-server manifest 캐시(`--repo-cache-expiration` 기본 24h) 때문에 git revision이 그대로면 hard refresh 전까지 값이 반영되지 않았는데, 3m은 그보다 훨씬 빠르다. 대신 컴포넌트별로 ExternalSecret을 따로 두기 때문에 릴리스 하나가 3분마다 같은 KV path를 3번 읽는다. 서비스가 50개면 ExternalSecret이 약 150개가 되고, 저장소에는 초당 약 0.8 read가 상시로 깔린다. 이 부하가 부담되면 릴리스별로 `refreshInterval`을 올리면 된다.

`annotations`는 기본값이 비어 있다. ArgoCD sync wave처럼 배포 순서를 정하는 것은 차트가 아니라 각 레포가 판단할 일이다. DOS-3091의 수동 반영도 이 필드에 force-sync 어노테이션을 넣어서 처리한다.

cronjob-template은 차트 루트에 같은 필드를 `externalSecret`으로 둔다. 기존 `vault` 블록이 루트에 있는 것과 같은 위치다.

컴포넌트별 override는 두지 않는다. 기존 `global.vault`와 동일하게 릴리스 하나가 KV path 하나를 본다.

## 리소스 이름

| | avp | ESO |
| --- | --- | --- |
| 렌더링 리소스 | `Secret/document-server` | `ExternalSecret/document-server` |
| 실제 참조 Secret | `Secret/document-server` | `Secret/document-server-external-secrets` |

ExternalSecret은 kind가 달라서 avp Secret과 이름이 같아도 충돌하지 않는다. 동기화 대상 Secret 이름에만 `-external-secrets` 접미사를 붙여 두 경로를 동시에 켤 수 있게 한다.

## 렌더링 결과

```yaml
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: document-server
  labels:
    {{ application.server.labels }}
spec:
  refreshInterval: 3m
  secretStoreRef:
    kind: ClusterSecretStore
    name: openbao
  target:
    name: document-server-external-secrets
    creationPolicy: Owner
  dataFrom:
    - extract:
        key: stage-default/application/document
```

`dataFrom.extract`를 쓰므로 KV path의 모든 키가 그대로 Secret 키가 되고 env 이름이 된다. 서비스가 secret을 추가할 때 차트 values를 건드릴 필요가 없다.

`creationPolicy: Owner`라 ExternalSecret이 지워지면 Secret도 같이 지워진다.

## env 주입

`envFrom`에 avp 블록 앞, configMap 블록 뒤에 넣는다.

```yaml
        {{- if .Values.global.externalSecret.enabled }}
          - secretRef:
              name: {{ include "application.server.externalSecretName" . }}
        {{- end }}
```

Kubernetes는 `envFrom` 뒤쪽 항목이 이기므로 두 경로를 동시에 켜면 avp 값이 ESO를 덮는다. 전환 중에 ESO가 기존 동작을 조용히 바꾸지 못하게 하려는 것이다. 서비스가 직접 지정한 `.Values.<component>.envFrom`은 맨 뒤라 둘 다 이긴다.

## 헬퍼

컴포넌트마다 대상 Secret 이름 헬퍼를 `_helpers.tpl`에 추가한다.

```
{{- define "application.server.externalSecretName" -}}
{{- printf "%s-external-secrets" (include "application.server.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
```

worker와 scheduler도 같은 형태로 둔다. cronjob-template은 컴포넌트 구분이 없으므로 `application.externalSecretName`으로 `application.name` 뒤에 접미사를 붙인다.

## 파일 변경

신규

- `charts/application-template/templates/server/external-secret.yaml`
- `charts/application-template/templates/worker/external-secret.yaml`
- `charts/application-template/templates/scheduler/external-secret.yaml`
- `charts/cronjob-template/templates/external-secret.yaml`
- `charts/application-template/tests/{server,worker,scheduler}/external_secret_test.yaml`
- `charts/cronjob-template/tests/external_secret_test.yaml`

수정

- `charts/application-template/templates/_helpers.tpl` 헬퍼 3개 추가
- `charts/application-template/templates/{server,worker,scheduler}/deployment.yaml` envFrom
- `charts/application-template/templates/{server,worker,scheduler}/rollout.yaml` envFrom
- `charts/application-template/values.yaml` `global.externalSecret` 추가
- `charts/application-template/Chart.yaml` 1.12.2 에서 1.13.0
- `charts/cronjob-template/templates/_helpers.tpl` 헬퍼 추가
- `charts/cronjob-template/templates/cron-job.yaml` envFrom
- `charts/cronjob-template/values.yaml` `externalSecret` 추가
- `charts/cronjob-template/Chart.yaml` 1.2.0 에서 1.3.0

README는 helm-docs가 values.yaml 주석에서 자동 생성한다.

## 테스트

helm-unittest suite를 신규 템플릿마다 둔다. envFrom 검증은 같은 suite에서 deployment, rollout, cron-job 템플릿을 함께 대상으로 잡는다. 검증 항목은 다음과 같다.

- `externalSecret.enabled=false`이면 문서가 렌더링되지 않는다
- 컴포넌트가 `enabled=false`이면 문서가 렌더링되지 않는다
- `enabled=true`이면 apiVersion, kind, metadata.name, target.name, secretStoreRef, dataFrom.extract.key가 값과 일치한다
- `refreshInterval` override가 반영된다
- deployment와 rollout의 envFrom에 대상 Secret의 secretRef가 들어간다
- avp와 ESO를 동시에 켜면 ESO secretRef가 avp 앞에 온다
- 서비스가 지정한 envFrom이 둘 뒤에 온다
- `annotations`가 비어 있으면 `metadata.annotations`가 렌더되지 않고, 넣은 키는 그대로 붙는다

## 알려진 제약

secret이 갱신돼도 pod은 자동 재시작되지 않는다. avp는 렌더 시점에 값이 있어서 `checksum/secret` 어노테이션으로 롤링이 걸렸지만 ESO는 차트가 값을 모른다. 차트에서 다루지 않고, 재시작이 필요한 서비스는 `podAnnotations`로 reloader 어노테이션을 붙이는 방식으로 values.yaml 주석에 안내한다.

DOS-3091의 수동 반영 요구사항은 `externalSecret.annotations`에 force-sync 어노테이션을 넣으면 Secret까지는 즉시 갱신된다. pod 재시작은 위와 같이 별개 문제다.

ExternalSecret과 워크로드가 같은 ArgoCD sync wave에 들어가므로, `path`가 틀렸거나 SecretStore가 없거나 저장소 권한이 없으면 sync는 성공으로 보고되고 새 pod만 `CreateContainerConfigError`로 뜨지 못한다. avp가 sync 시점에 실패하던 것과 다르다. 순서를 앞당기고 싶은 레포는 `annotations`에 `argocd.argoproj.io/sync-wave`를 직접 넣으면 된다.

## 마이그레이션

레포별로 `global.externalSecret.enabled=true`를 켜고 동기화된 Secret에 값이 제대로 들어왔는지 확인한 뒤 `global.vault.enabled=false`로 내린다. 두 단계 사이에는 Secret 두 개가 모두 붙어 있고 avp 값이 우선하므로, ESO를 켜는 것만으로는 동작이 바뀌지 않는다. 실제로 값이 바뀌는 시점은 avp를 내릴 때 하나뿐이다. 전환이 끝난 레포가 충분히 쌓이면 avp 경로 제거를 별도 작업으로 진행한다.
