# cronjob-template

![Version: 1.3.0](https://img.shields.io/badge/Version-1.3.0-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

A Helm chart for CronJob

**Homepage:** <https://app.modusign.co.kr>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| modusign |  | <https://github.com/modusign> |

## Requirements

Kubernetes: `>=1.23`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalLabels | object | `{}` | Common labels for the all resources |
| affinity | object | `{}` |  |
| cronJob | object | `{"concurrencyPolicy":null,"failedJobsHistoryLimit":1,"schedule":"* * * * *","successfulJobsHistoryLimit":3,"timeZone":null}` | CronJob resource configuration |
| cronJob.concurrencyPolicy | string | `nil` | Either: `Allow`, `Forbid` or `Replace` |
| cronJob.failedJobsHistoryLimit | int | `1` (defaults to 1 if not specified) | Number that specifies the desired number of failed finished jobs the cron job should be run with. |
| cronJob.schedule | string | `"* * * * *"` | refer https://kubernetes.io/ko/docs/concepts/workloads/controllers/cron-jobs/#%ED%81%AC%EB%A1%A0-%EC%8A%A4%EC%BC%80%EC%A4%84-%EB%AC%B8%EB%B2%95 |
| cronJob.successfulJobsHistoryLimit | int | `3` (defaults to 3 if not specified) | Number that specifies the desired number of successful finished jobs the cron job should be run with. |
| cronJob.timeZone | string | `nil` | Available timezone evalues are listed in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones |
| env | object | `{}` | Environment variables to pass to all deployed Deployments |
| envFrom | list | `[]` | envfrom in server deployment |
| externalSecret | object | `{"annotations":{"argocd.argoproj.io/sync-wave":"-1"},"enabled":false,"path":"stage-default/application/${service}","refreshInterval":"3m","store":{"kind":"ClusterSecretStore","name":"openbao"}}` | OpenBao KV secret을 External Secrets Operator로 가져와 env로 주입한다 |
| externalSecret.annotations | object | `{"argocd.argoproj.io/sync-wave":"-1"}` | ExternalSecret에 붙일 어노테이션. 기본 sync-wave는 ESO가 Secret을 만든 뒤 워크로드가 뜨도록 보장한다. 즉시 재동기화가 필요하면 `force-sync: <timestamp>`를 추가한다 null로 두면 sync-wave 자체가 사라진다. 키를 추가하면 기본값과 병합되고, 완전히 덮어쓰려면 null로 지운 뒤 다시 채워야 한다 |
| externalSecret.path | string | `"stage-default/application/${service}"` | OpenBao KV path. 이 path의 모든 키가 그대로 env 이름이 된다 |
| externalSecret.refreshInterval | string | `"3m"` | ESO가 OpenBao를 다시 읽는 주기. secret이 갱신돼도 pod은 자동 재시작되지 않는다 |
| externalSecret.store | object | `{"kind":"ClusterSecretStore","name":"openbao"}` | 인프라 레포에서 관리하는 SecretStore 참조. 차트는 SecretStore CR을 만들지 않는다 |
| extraArgs | list | `[]` | Additional command line arguments to pass to the job container |
| extraCommands | list | `[]` | Additional command line arguments to pass to the job container |
| extraSecrets | list | `[]` | extra secrets to pass to server |
| image.hub | string | `"harbor.modusign.co.kr/modusign"` | hub applied to all deployments |
| image.imagePullPolicy | string | `"IfNotPresent"` | imagePullPolicy applied to all deployments |
| image.repository | string | `"cronjob-template"` | repository applied to all deployments |
| image.tag | string | `"1.0.0"` | global image tag |
| imagePullSecrets | list | `[]` | Secrets with credentials to pull images from a private registry |
| initContainers | list | `[]` | Init containers to add to the application server pod |
| job | object | `{"completions":null,"parallelism":null}` | Job resource configuration which is created by CronJob |
| job.completions | string | `1` (defaults to 1 if not specified) | Number of successful finished jobs to retain. |
| job.parallelism | string | `1` (defaults to 1 if not specified) | Specifies the maximum desired number of pods running at the same time |
| lifecycle | object | `{}` | Specify postStart and preStop lifecycle hooks for your container |
| name | string | `"cronjob-template"` | name |
| nodeSelector | object | `{}` | Default node selector for all components |
| observability.datadog | object | `{"admissionController":{"enabled":false}}` | inject datadog admission controller env label |
| podAnnotations | object | `{}` | Annotations for the all deployed pods |
| podLabels | object | `{}` | Labels for the all deployed pods |
| resources | object | `{"limits":{"cpu":"800m","memory":"1600Mi"},"requests":{"cpu":"400m","memory":"800Mi"}}` | Resource limits and requests for the server |
| restartPolicy | string | `"OnFailure"` |  |
| runtimeEnv | string | `"stage"` | Runtime env for app.kubernetes.io/env, env, tags.datadoghq.com/env labels |
| securityContext | object | `{}` | Security context for container |
| serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials for the Service Account |
| serviceAccount.create | bool | `true` | Create server service account |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull Secrets for the Service Account |
| serviceAccount.labels | object | `{}` | Labels applied to created service account |
| serviceAccount.name | string | `"cronjob-template"` | Server service account name |
| terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds for container lifecycle hook |
| tolerations | list | `[]` | Default tolerations for all components |
| topologySpreadConstraints | list | `[]` | Default [TopologySpreadConstraints] rules for all components # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector of the component |
| vault | object | `{"enabled":false,"path":"stage-default/application/${service}","secrets":{}}` | Secrets variables to pass to all deployed Deployments by argocd vault plugin |
| volumeMounts | list | `[]` | Additional volumeMounts to the application server main container |
| volumes | list | `[]` | Additional volumes to the application server pod |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
