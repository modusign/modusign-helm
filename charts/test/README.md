# document

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

modusign document service

**Homepage:** <https://app.modusign.co.kr>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| KIM TAEYOUNG | <ty.kim@modusign.co.kr> | <https://github.com/orgs/modusign/people/kty1965> |
| CHOI HYUNSEOK | <hs.choi@modusign.co.kr> | <https://github.com/orgs/modusign/people/hschoi1104> |
| KIM HYUNYOUNG | <hy.kim@modusign.co.kr> | <https://github.com/orgs/modusign/people/atobaum> |

## Source Code

* <https://github.com/modusign/document>

## Requirements

Kubernetes: `>=1.23`

| Repository | Name | Version |
|------------|------|---------|
| https://modusign.github.io/modusign-helm | application-template(application-template) | 1.2.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| application-template.global.additionalLabels | object | `{}` | Common labels for the all resources |
| application-template.global.affinity | object | `{}` |  |
| application-template.global.deploymentAnnotations | object | `{}` | Annotations for the all deployed Deployments |
| application-template.global.deploymentStrategy | object | `{}` | Deployment strategy to be added to the all Deployment |
| application-template.global.env | object | `{}` | Environment variables to pass to all deployed Deployments |
| application-template.global.image.hub | string | `"harbor.modusign.co.kr/modusign"` | hub applied to all deployments |
| application-template.global.image.imagePullPolicy | string | `"IfNotPresent"` | imagePullPolicy applied to all deployments |
| application-template.global.image.repository | string | `"application-template"` | repository applied to all deployments |
| application-template.global.image.tag | string | `"1.0.0"` | global image tag |
| application-template.global.imagePullSecrets | list | `[]` | Secrets with credentials to pull images from a private registry |
| application-template.global.minReadySeconds | int | `60` | optional field that specifies the minimum number of seconds for which a newly created Pod should be ready without any of its containers crashing |
| application-template.global.nodeSelector | object | `{}` | Default node selector for all components |
| application-template.global.observability.datadog | object | `{"admissionController":{"enabled":false}}` | inject datadog admission controller env label |
| application-template.global.podAnnotations | object | `{}` | Annotations for the all deployed pods |
| application-template.global.podLabels | object | `{}` | Labels for the all deployed pods |
| application-template.global.revisionHistoryLimit | int | `3` | Number of old deployment ReplicaSets to retain. The rest will be garbage collected. |
| application-template.global.rolloutAnalysis | object | `{}` | Rollout analysis to be added to the all Rollout |
| application-template.global.serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| application-template.global.serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials for the Service Account |
| application-template.global.serviceAccount.imagePullSecrets | list | `[]` | Image pull Secrets for the Service Account |
| application-template.global.serviceAccount.labels | object | `{}` | Labels applied to created service account |
| application-template.global.tolerations | list | `[]` | Default tolerations for all components |
| application-template.global.topologySpreadConstraints | list | `[]` | Default [TopologySpreadConstraints] rules for all components # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector of the component |
| application-template.global.vault | object | `{"enabled":false,"path":"stage-default/application/${service}","secrets":{}}` | Secrets variables to pass to all deployed Deployments by argocd vault plugin |
| application-template.scheduler.affinity | object | `{}` (defaults to global.affinity preset) | Assign custom [affinity] rules to the deployment |
| application-template.scheduler.autoscaling.behavior | object | `{}` | Configures the scaling behavior of the target in both Up and Down directions. |
| application-template.scheduler.autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaler ([HPA]) for the scheduler |
| application-template.scheduler.autoscaling.maxReplicas | int | `5` | Maximum number of replicas for the scheduler [HPA] |
| application-template.scheduler.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the scheduler [HPA] |
| application-template.scheduler.autoscaling.scaleTargetRef | object | `{}` |  |
| application-template.scheduler.autoscaling.targetCPUUtilizationPercentage | int | `80` | If targetCPUUtilizationPercentage is set to 0, the autoscaler will not take CPU metrics into consideration while calculating the number of replicas. |
| application-template.scheduler.autoscaling.targetMemoryUtilizationPercentage | int | `0` | If targetMemoryUtilizationPercentage is set to 0, the autoscaler will not take memory metrics into consideration while calculating the number of replicas. |
| application-template.scheduler.deploymentAnnotations | object | `{}` | Annotations to be added to scheduler Deployment |
| application-template.scheduler.deploymentStrategy | object | `{}` | Deployment strategy to be added to the scheduler Deployment |
| application-template.scheduler.enabled | bool | `false` |  |
| application-template.scheduler.envFrom | list | `[]` | envfrom in server deployment |
| application-template.scheduler.extraArgs | list | `[]` | Additional command line arguments to pass to server |
| application-template.scheduler.extraCommands | list | `[]` | Additional command line arguments to pass to server |
| application-template.scheduler.image.hub | string | `""` | hub applied to scheduler deployments |
| application-template.scheduler.image.imagePullPolicy | string | `""` | imagePullPolicy applied to scheduler deployments |
| application-template.scheduler.image.repository | string | `""` | repository applied to scheduler deployments |
| application-template.scheduler.image.tag | string | `""` | global image tag |
| application-template.scheduler.initContainers | list | `[]` | Init containers to add to the application scheduler pod |
| application-template.scheduler.istio.destinationRules | list | `[]` | destinationRule configuration |
| application-template.scheduler.istio.enabled | bool | `false` | Create istio resources |
| application-template.scheduler.istio.ingressGateways | list | `[]` | ingress gateway configuration |
| application-template.scheduler.istio.virtualServices | list | `[]` | virtualService configuration |
| application-template.scheduler.lifecycle | object | `{}` | Specify postStart and preStop lifecycle hooks for your container |
| application-template.scheduler.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| application-template.scheduler.livenessProbe.httpGet.path | string | `"/health"` |  |
| application-template.scheduler.livenessProbe.httpGet.port | int | `3000` |  |
| application-template.scheduler.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| application-template.scheduler.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| application-template.scheduler.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| application-template.scheduler.livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| application-template.scheduler.name | string | `"application-template-scheduler"` | scheduler name |
| application-template.scheduler.nodeSelector | object | `{}` (defaults to global.nodeSelector) | [Node selector] |
| application-template.scheduler.pdb.annotations | object | `{}` | Annotations to be added to scheduler pdb |
| application-template.scheduler.pdb.enabled | bool | `false` | Deploy a [PodDisruptionBudget] for the scheduler |
| application-template.scheduler.pdb.labels | object | `{}` | Labels to be added to scheduler pdb |
| application-template.scheduler.pdb.maxUnavailable | string | `""` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%). # Has higher precedence over `scheduler.pdb.minAvailable` |
| application-template.scheduler.pdb.minAvailable | string | `""` (defaults to 0 if not specified) | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| application-template.scheduler.podAnnotations | object | `{}` | Annotations to be added to scheduler pods |
| application-template.scheduler.podLabels | object | `{}` | Labels to be added to scheduler pods |
| application-template.scheduler.ports[0].name | string | `"http"` |  |
| application-template.scheduler.ports[0].port | int | `80` |  |
| application-template.scheduler.ports[0].targetPort | int | `3000` |  |
| application-template.scheduler.readinessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| application-template.scheduler.readinessProbe.httpGet.path | string | `"/health"` |  |
| application-template.scheduler.readinessProbe.httpGet.port | int | `3000` |  |
| application-template.scheduler.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| application-template.scheduler.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| application-template.scheduler.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| application-template.scheduler.readinessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| application-template.scheduler.replicas | int | `1` | The number of scheduler pods to run |
| application-template.scheduler.resources | object | `{}` | Resource limits and requests for the scheduler |
| application-template.scheduler.rolloutAnalysis | object | `{}` | Rollout analysis to be added to the scheduler Rollout |
| application-template.scheduler.serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| application-template.scheduler.serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials for the Service Account |
| application-template.scheduler.serviceAccount.create | bool | `true` | Create global service account |
| application-template.scheduler.serviceAccount.imagePullSecrets | list | `[]` | Image pull Secrets for the Service Account |
| application-template.scheduler.serviceAccount.labels | object | `{}` | Labels applied to created service account |
| application-template.scheduler.serviceAccount.name | string | `"application-template-scheduler"` | Server service account name |
| application-template.scheduler.terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds for container lifecycle hook |
| application-template.scheduler.tolerations | list | `[]` (defaults to global.tolerations) | [Tolerations] for use with node taints |
| application-template.scheduler.topologySpreadConstraints | list | `[]` (defaults to global.topologySpreadConstraints) | Assign custom [TopologySpreadConstraints] rules to the scheduler # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector configuration of the deployment |
| application-template.scheduler.volumeMounts | list | `[]` | Additional volumeMounts to the application scheduler main container |
| application-template.scheduler.volumes | list | `[]` | Additional volumes to the application scheduler pod |
| application-template.scheduler.workload | string | `"deployment"` | set deployment kind to Rollouts rollout:   enabled : false |
| application-template.server.affinity | object | `{}` (defaults to global.affinity preset) | Assign custom [affinity] rules to the deployment |
| application-template.server.autoscaling.behavior | object | `{}` | Configures the scaling behavior of the target in both Up and Down directions. |
| application-template.server.autoscaling.enabled | bool | `true` | Enable Horizontal Pod Autoscaler ([HPA]) for the server |
| application-template.server.autoscaling.maxReplicas | int | `5` | Maximum number of replicas for the server [HPA] |
| application-template.server.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the server [HPA] |
| application-template.server.autoscaling.scaleTargetRef.apiVersion | string | `"argoproj.io/v1alpha1"` |  |
| application-template.server.autoscaling.scaleTargetRef.kind | string | `"Rollout"` |  |
| application-template.server.autoscaling.scaleTargetRef.name | string | `"application-template-server"` |  |
| application-template.server.autoscaling.targetCPUUtilizationPercentage | int | `80` | If targetCPUUtilizationPercentage is set to 0, the autoscaler will not take CPU metrics into consideration while calculating the number of replicas. |
| application-template.server.autoscaling.targetMemoryUtilizationPercentage | int | `0` | If targetMemoryUtilizationPercentage is set to 0, the autoscaler will not take memory metrics into consideration while calculating the number of replicas. |
| application-template.server.deploymentAnnotations | object | `{}` | Annotations to be added to server Deployment |
| application-template.server.deploymentStrategy | object | `{}` | Deployment strategy to be added to the server Deployment |
| application-template.server.enabled | bool | `true` |  |
| application-template.server.envFrom | list | `[]` | envfrom in server deployment |
| application-template.server.extraArgs | list | `[]` | Additional command line arguments to pass to server |
| application-template.server.extraCommands | list | `[]` | Additional command line arguments to pass to server |
| application-template.server.image.hub | string | `""` | hub applied to server deployments |
| application-template.server.image.imagePullPolicy | string | `""` | imagePullPolicy applied to server deployments |
| application-template.server.image.repository | string | `""` | repository applied to server deployments |
| application-template.server.image.tag | string | `""` | global image tag |
| application-template.server.initContainers | list | `[]` | Init containers to add to the application server pod |
| application-template.server.istio.destinationRules | list | `[]` | destinationRule configuration |
| application-template.server.istio.enabled | bool | `true` | Create istio resources |
| application-template.server.istio.ingressGateways | list | `[]` | ingress gateway configuration |
| application-template.server.istio.virtualServices | list | `[]` | virtualService configuration |
| application-template.server.lifecycle | object | `{}` | Specify postStart and preStop lifecycle hooks for your container |
| application-template.server.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| application-template.server.livenessProbe.httpGet.path | string | `"/health"` |  |
| application-template.server.livenessProbe.httpGet.port | int | `3000` |  |
| application-template.server.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| application-template.server.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| application-template.server.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| application-template.server.livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| application-template.server.name | string | `"application-template"` | server name |
| application-template.server.nodeSelector | object | `{}` (defaults to global.nodeSelector) | [Node selector] |
| application-template.server.pdb.annotations | object | `{}` | Annotations to be added to server pdb |
| application-template.server.pdb.enabled | bool | `true` | Deploy a [PodDisruptionBudget] for the server |
| application-template.server.pdb.labels | object | `{}` | Labels to be added to server pdb |
| application-template.server.pdb.maxUnavailable | string | `""` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%). # Has higher precedence over `server.pdb.minAvailable` |
| application-template.server.pdb.minAvailable | int | `""` (defaults to 0 if not specified) | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| application-template.server.podAnnotations | object | `{}` | Annotations to be added to server pods |
| application-template.server.podLabels | object | `{}` | Labels to be added to server pods |
| application-template.server.ports[0].name | string | `"http"` |  |
| application-template.server.ports[0].port | int | `80` |  |
| application-template.server.ports[0].targetPort | int | `3000` |  |
| application-template.server.readinessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| application-template.server.readinessProbe.httpGet.path | string | `"/health"` |  |
| application-template.server.readinessProbe.httpGet.port | int | `3000` |  |
| application-template.server.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| application-template.server.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| application-template.server.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| application-template.server.readinessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| application-template.server.replicas | int | `1` | The number of server pods to run |
| application-template.server.resources | object | `{"limits":{"cpu":"800m","memory":"1600Mi"},"requests":{"cpu":"400m","memory":"800Mi"}}` | Resource limits and requests for the server |
| application-template.server.rolloutAnalysis | object | `{"successfulRunHistoryLimit":1,"unsuccessfulRunHistoryLimit":3}` | Rollout analysis to be added to the server Rollout |
| application-template.server.serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| application-template.server.serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials for the Service Account |
| application-template.server.serviceAccount.create | bool | `true` | Create server service account |
| application-template.server.serviceAccount.imagePullSecrets | list | `[]` | Image pull Secrets for the Service Account |
| application-template.server.serviceAccount.labels | object | `{}` | Labels applied to created service account |
| application-template.server.serviceAccount.name | string | `"application-template-server"` | Server service account name |
| application-template.server.terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds for container lifecycle hook |
| application-template.server.tolerations | list | `[]` (defaults to global.tolerations) | [Tolerations] for use with node taints |
| application-template.server.topologySpreadConstraints | list | `[]` (defaults to global.topologySpreadConstraints) | Assign custom [TopologySpreadConstraints] rules to the server # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector configuration of the deployment |
| application-template.server.volumeMounts | list | `[]` | Additional volumeMounts to the application server main container |
| application-template.server.volumes | list | `[]` | Additional volumes to the application server pod |
| application-template.server.workload | string | `"rollout"` | set deployment kind to Rollouts rollout:   enabled : false |
| application-template.worker.affinity | object | `{}` (defaults to global.affinity preset) | Assign custom [affinity] rules to the deployment |
| application-template.worker.autoscaling.behavior | object | `{}` | Configures the scaling behavior of the target in both Up and Down directions. |
| application-template.worker.autoscaling.enabled | bool | `true` | Enable Horizontal Pod Autoscaler ([HPA]) for the worker |
| application-template.worker.autoscaling.maxReplicas | int | `5` | Maximum number of replicas for the worker [HPA] |
| application-template.worker.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the worker [HPA] |
| application-template.worker.autoscaling.scaleTargetRef | object | `{"apiVersion":"apps/v1","kind":"Deployment","name":"application-template-worker"}` | scaleTargetRef.name is same value with worker.name |
| application-template.worker.autoscaling.targetCPUUtilizationPercentage | int | `80` | If targetCPUUtilizationPercentage is set to 0, the autoscaler will not take CPU metrics into consideration while calculating the number of replicas. |
| application-template.worker.autoscaling.targetMemoryUtilizationPercentage | int | `0` | If targetMemoryUtilizationPercentage is set to 0, the autoscaler will not take memory metrics into consideration while calculating the number of replicas. |
| application-template.worker.deploymentAnnotations | object | `{}` | Annotations to be added to worker Deployment |
| application-template.worker.deploymentStrategy | object | `{}` | Deployment strategy to be added to the worker Deployment |
| application-template.worker.enabled | bool | `false` |  |
| application-template.worker.envFrom | list | `[]` | envfrom in server deployment |
| application-template.worker.extraArgs | list | `[]` | Additional command line arguments to pass to server |
| application-template.worker.extraCommands | list | `[]` | Additional command line arguments to pass to server |
| application-template.worker.image.hub | string | `""` | hub applied to worker deployments |
| application-template.worker.image.imagePullPolicy | string | `""` | imagePullPolicy applied to worker deployments |
| application-template.worker.image.repository | string | `""` | repository applied to worker deployments |
| application-template.worker.image.tag | string | `""` | global image tag |
| application-template.worker.initContainers | list | `[]` | Init containers to add to the application worker pod |
| application-template.worker.istio.destinationRules | list | `[]` | destinationRule configuration |
| application-template.worker.istio.enabled | bool | `false` | Create istio resources |
| application-template.worker.istio.ingressGateways | list | `[]` | ingress gateway configuration |
| application-template.worker.istio.virtualServices | list | `[]` | virtualService configuration |
| application-template.worker.lifecycle | object | `{}` | Specify postStart and preStop lifecycle hooks for your container |
| application-template.worker.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| application-template.worker.livenessProbe.httpGet.path | string | `"/health"` |  |
| application-template.worker.livenessProbe.httpGet.port | int | `3000` |  |
| application-template.worker.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| application-template.worker.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| application-template.worker.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| application-template.worker.livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| application-template.worker.name | string | `"application-template-worker"` | worker name |
| application-template.worker.nodeSelector | object | `{}` (defaults to global.nodeSelector) | [Node selector] |
| application-template.worker.pdb.annotations | object | `{}` | Annotations to be added to worker pdb |
| application-template.worker.pdb.enabled | bool | `false` | Deploy a [PodDisruptionBudget] for the worker |
| application-template.worker.pdb.labels | object | `{}` | Labels to be added to worker pdb |
| application-template.worker.pdb.maxUnavailable | string | `""` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%). # Has higher precedence over `worker.pdb.minAvailable` |
| application-template.worker.pdb.minAvailable | string | `""` (defaults to 0 if not specified) | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| application-template.worker.podAnnotations | object | `{}` | Annotations to be added to worker pods |
| application-template.worker.podLabels | object | `{}` | Labels to be added to worker pods |
| application-template.worker.ports[0].name | string | `"http"` |  |
| application-template.worker.ports[0].port | int | `80` |  |
| application-template.worker.ports[0].targetPort | int | `3000` |  |
| application-template.worker.readinessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the [probe] to be considered failed after having succeeded |
| application-template.worker.readinessProbe.httpGet.path | string | `"/health"` |  |
| application-template.worker.readinessProbe.httpGet.port | int | `3000` |  |
| application-template.worker.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before [probe] is initiated |
| application-template.worker.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the [probe] |
| application-template.worker.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the [probe] to be considered successful after having failed |
| application-template.worker.readinessProbe.timeoutSeconds | int | `1` | Number of seconds after which the [probe] times out |
| application-template.worker.replicas | int | `1` | The number of worker pods to run |
| application-template.worker.resources | object | `{}` | Resource limits and requests for the worker |
| application-template.worker.rolloutAnalysis | object | `{}` | Rollout analysis to be added to the worker Rollout |
| application-template.worker.serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| application-template.worker.serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials for the Service Account |
| application-template.worker.serviceAccount.create | bool | `true` | Create global service account |
| application-template.worker.serviceAccount.imagePullSecrets | list | `[]` | Image pull Secrets for the Service Account |
| application-template.worker.serviceAccount.labels | object | `{}` | Labels applied to created service account |
| application-template.worker.serviceAccount.name | string | `"application-template-worker"` | Server service account name |
| application-template.worker.terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds for container lifecycle hook |
| application-template.worker.tolerations | list | `[]` (defaults to global.tolerations) | [Tolerations] for use with node taints |
| application-template.worker.topologySpreadConstraints | list | `[]` (defaults to global.topologySpreadConstraints) | Assign custom [TopologySpreadConstraints] rules to the worker # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector configuration of the deployment |
| application-template.worker.volumeMounts | list | `[]` | Additional volumeMounts to the application worker main container |
| application-template.worker.volumes | list | `[]` | Additional volumes to the application worker pod |
| application-template.worker.workload | string | `"deployment"` | set deployment kind to Rollouts rollout:   enabled : false |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
