# application-template

![Version: 1.2.0](https://img.shields.io/badge/Version-1.2.0-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

A Helm chart for Modusign Applications

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
| global.additionalLabels | object | `{}` | Common labels for the all resources |
| global.affinity | object | `{}` |  |
| global.deploymentAnnotations | object | `{}` | Annotations for the all deployed Deployments |
| global.deploymentStrategy | object | `{}` | Deployment strategy to be added to the all Deployment |
| global.env | object | `{}` | Environment variables to pass to all deployed Deployments |
| global.image.hub | string | `"harbor.modusign.co.kr/modusign"` | hub applied to all deployments |
| global.image.imagePullPolicy | string | `"IfNotPresent"` | imagePullPolicy applied to all deployments |
| global.image.repository | string | `"application-template"` | repository applied to all deployments |
| global.image.tag | string | `"1.0.0"` | global image tag |
| global.imagePullSecrets | list | `[]` | Secrets with credentials to pull images from a private registry |
| global.minReadySeconds | int | `60` | optional field that specifies the minimum number of seconds for which a newly created Pod should be ready without any of its containers crashing |
| global.nodeSelector | object | `{}` | Default node selector for all components |
| global.observability.datadog | object | `{"admissionController":{"enabled":false}}` | inject datadog admission controller env label |
| global.podAnnotations | object | `{}` | Annotations for the all deployed pods |
| global.podLabels | object | `{}` | Labels for the all deployed pods |
| global.revisionHistoryLimit | int | `3` | Number of old deployment ReplicaSets to retain. The rest will be garbage collected. |
| global.rolloutAnalysis | object | `{}` | Rollout analysis to be added to the all Rollout |
| global.serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| global.serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials for the Service Account |
| global.serviceAccount.imagePullSecrets | list | `[]` | Image pull Secrets for the Service Account |
| global.serviceAccount.labels | object | `{}` | Labels applied to created service account |
| global.tolerations | list | `[]` | Default tolerations for all components |
| global.topologySpreadConstraints | list | `[]` | Default [TopologySpreadConstraints] rules for all components # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector of the component |
| global.vault | object | `{"enabled":false,"path":"stage-default/application/${service}","secrets":{}}` | Secrets variables to pass to all deployed Deployments by argocd vault plugin |
| scheduler.affinity | object | `{}` (defaults to global.affinity preset) | Assign custom [affinity] rules to the deployment |
| scheduler.autoscaling.behavior | object | `{}` | Configures the scaling behavior of the target in both Up and Down directions. |
| scheduler.autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaler ([HPA]) for the scheduler |
| scheduler.autoscaling.maxReplicas | int | `5` | Maximum number of replicas for the scheduler [HPA] |
| scheduler.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the scheduler [HPA] |
| scheduler.autoscaling.scaleTargetRef | object | `{}` |  |
| scheduler.autoscaling.targetCPUUtilizationPercentage | int | `80` | If targetCPUUtilizationPercentage is set to 0, the autoscaler will not take CPU metrics into consideration while calculating the number of replicas. |
| scheduler.autoscaling.targetMemoryUtilizationPercentage | int | `0` | If targetMemoryUtilizationPercentage is set to 0, the autoscaler will not take memory metrics into consideration while calculating the number of replicas. |
| scheduler.deploymentAnnotations | object | `{}` | Annotations to be added to scheduler Deployment |
| scheduler.deploymentStrategy | object | `{}` | Deployment strategy to be added to the scheduler Deployment |
| scheduler.enabled | bool | `false` |  |
| scheduler.envFrom | list | `[]` | envfrom in scheduler deployment |
| scheduler.extraArgs | list | `[]` | Additional command line arguments to pass to scheduler |
| scheduler.extraCommands | list | `[]` | Additional command line arguments to pass to scheduler |
| scheduler.extraConfigMaps | list | `[]` | Additional configMaps to pass to scheduler |
| scheduler.extraEnvs | list | `[]` | extra envs to pass to shceduler |
| scheduler.extraSecrets | list | `[]` | extra secrets to pass to scheduler |
| scheduler.image.hub | string | `""` | hub applied to scheduler deployments |
| scheduler.image.imagePullPolicy | string | `""` | imagePullPolicy applied to scheduler deployments |
| scheduler.image.repository | string | `""` | repository applied to scheduler deployments |
| scheduler.image.tag | string | `""` | global image tag |
| scheduler.initContainers | list | `[]` | Init containers to add to the application scheduler pod |
| scheduler.istio.destinationRules | list | `[]` | destinationRule configuration |
| scheduler.istio.enabled | bool | `false` | Create istio resources |
| scheduler.istio.ingressGateways | list | `[]` | ingress gateway configuration |
| scheduler.istio.virtualServices | list | `[]` | virtualService configuration |
| scheduler.lifecycle | object | `{}` | Specify postStart and preStop lifecycle hooks for your container |
| scheduler.name | string | `"application-template-scheduler"` | scheduler name |
| scheduler.nodeSelector | object | `{}` (defaults to global.nodeSelector) | [Node selector] |
| scheduler.pdb.annotations | object | `{}` | Annotations to be added to scheduler pdb |
| scheduler.pdb.enabled | bool | `false` | Deploy a [PodDisruptionBudget] for the scheduler |
| scheduler.pdb.labels | object | `{}` | Labels to be added to scheduler pdb |
| scheduler.pdb.maxUnavailable | string | `""` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%). # Has higher precedence over `scheduler.pdb.minAvailable` |
| scheduler.pdb.minAvailable | string | `""` (defaults to 0 if not specified) | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| scheduler.podAnnotations | object | `{}` | Annotations to be added to scheduler pods |
| scheduler.podLabels | object | `{}` | Labels to be added to scheduler pods |
| scheduler.ports[0].name | string | `"http"` |  |
| scheduler.ports[0].port | int | `80` |  |
| scheduler.ports[0].targetPort | int | `3000` |  |
| scheduler.replicas | int | `1` | The number of scheduler pods to run |
| scheduler.resources | object | `{}` | Resource limits and requests for the scheduler |
| scheduler.rolloutAnalysis | object | `{}` | Rollout analysis to be added to the scheduler Rollout |
| scheduler.serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| scheduler.serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials for the Service Account |
| scheduler.serviceAccount.create | bool | `true` | Create global service account |
| scheduler.serviceAccount.imagePullSecrets | list | `[]` | Image pull Secrets for the Service Account |
| scheduler.serviceAccount.labels | object | `{}` | Labels applied to created service account |
| scheduler.serviceAccount.name | string | `"application-template-scheduler"` | Server service account name |
| scheduler.terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds for container lifecycle hook |
| scheduler.tolerations | list | `[]` (defaults to global.tolerations) | [Tolerations] for use with node taints |
| scheduler.topologySpreadConstraints | list | `[]` (defaults to global.topologySpreadConstraints) | Assign custom [TopologySpreadConstraints] rules to the scheduler # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector configuration of the deployment |
| scheduler.volumeMounts | list | `[]` | Additional volumeMounts to the application scheduler main container |
| scheduler.volumes | list | `[]` | Additional volumes to the application scheduler pod |
| scheduler.workload | string | `"deployment"` | set deployment kind to Rollouts rollout:   enabled : false |
| server.affinity | object | `{}` (defaults to global.affinity preset) | Assign custom [affinity] rules to the deployment |
| server.autoscaling.behavior | object | `{}` | Configures the scaling behavior of the target in both Up and Down directions. |
| server.autoscaling.enabled | bool | `true` | Enable Horizontal Pod Autoscaler ([HPA]) for the server |
| server.autoscaling.maxReplicas | int | `5` | Maximum number of replicas for the server [HPA] |
| server.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the server [HPA] |
| server.autoscaling.scaleTargetRef.apiVersion | string | `"argoproj.io/v1alpha1"` |  |
| server.autoscaling.scaleTargetRef.kind | string | `"Rollout"` |  |
| server.autoscaling.scaleTargetRef.name | string | `"application-template-server"` |  |
| server.autoscaling.targetCPUUtilizationPercentage | int | `80` | If targetCPUUtilizationPercentage is set to 0, the autoscaler will not take CPU metrics into consideration while calculating the number of replicas. |
| server.autoscaling.targetMemoryUtilizationPercentage | int | `0` | If targetMemoryUtilizationPercentage is set to 0, the autoscaler will not take memory metrics into consideration while calculating the number of replicas. |
| server.deploymentAnnotations | object | `{}` | Annotations to be added to server Deployment |
| server.deploymentStrategy | object | `{}` | Deployment strategy to be added to the server Deployment |
| server.enabled | bool | `true` |  |
| server.envFrom | list | `[]` | envfrom in server deployment |
| server.extraArgs | list | `[]` | Additional command line arguments to pass to server |
| server.extraCommands | list | `[]` | Additional command line arguments to pass to server |
| server.extraConfigMaps | list | `[]` | Additional configMaps to pass to server |
| server.extraEnvs | list | `[]` | extra envs to pass to server |
| server.extraSecrets | list | `[]` | extra secrets to pass to server |
| server.image.hub | string | `""` | hub applied to server deployments |
| server.image.imagePullPolicy | string | `""` | imagePullPolicy applied to server deployments |
| server.image.repository | string | `""` | repository applied to server deployments |
| server.image.tag | string | `""` | global image tag |
| server.initContainers | list | `[]` | Init containers to add to the application server pod |
| server.istio.destinationRules | list | `[]` | destinationRule configuration |
| server.istio.enabled | bool | `true` | Create istio resources |
| server.istio.ingressGateways | list | `[]` | ingress gateway configuration |
| server.istio.virtualServices | list | `[]` | virtualService configuration |
| server.lifecycle | object | `{}` | Specify postStart and preStop lifecycle hooks for your container |
| server.name | string | `"application-template"` | server name |
| server.nodeSelector | object | `{}` (defaults to global.nodeSelector) | [Node selector] |
| server.pdb.annotations | object | `{}` | Annotations to be added to server pdb |
| server.pdb.enabled | bool | `true` | Deploy a [PodDisruptionBudget] for the server |
| server.pdb.labels | object | `{}` | Labels to be added to server pdb |
| server.pdb.maxUnavailable | string | `""` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%). # Has higher precedence over `server.pdb.minAvailable` |
| server.pdb.minAvailable | int | `""` (defaults to 0 if not specified) | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| server.podAnnotations | object | `{}` | Annotations to be added to server pods |
| server.podLabels | object | `{}` | Labels to be added to server pods |
| server.ports[0].name | string | `"http"` |  |
| server.ports[0].port | int | `80` |  |
| server.ports[0].targetPort | int | `3000` |  |
| server.replicas | int | `1` | The number of server pods to run |
| server.resources | object | `{"limits":{"cpu":"800m","memory":"1600Mi"},"requests":{"cpu":"400m","memory":"800Mi"}}` | Resource limits and requests for the server |
| server.rolloutAnalysis | object | `{"successfulRunHistoryLimit":1,"unsuccessfulRunHistoryLimit":3}` | Rollout analysis to be added to the server Rollout |
| server.serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| server.serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials for the Service Account |
| server.serviceAccount.create | bool | `true` | Create server service account |
| server.serviceAccount.imagePullSecrets | list | `[]` | Image pull Secrets for the Service Account |
| server.serviceAccount.labels | object | `{}` | Labels applied to created service account |
| server.serviceAccount.name | string | `"application-template-server"` | Server service account name |
| server.terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds for container lifecycle hook |
| server.tolerations | list | `[]` (defaults to global.tolerations) | [Tolerations] for use with node taints |
| server.topologySpreadConstraints | list | `[]` (defaults to global.topologySpreadConstraints) | Assign custom [TopologySpreadConstraints] rules to the server # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector configuration of the deployment |
| server.volumeMounts | list | `[]` | Additional volumeMounts to the application server main container |
| server.volumes | list | `[]` | Additional volumes to the application server pod |
| server.workload | string | `"rollout"` | set deployment kind to Rollouts rollout:   enabled : false |
| worker.affinity | object | `{}` (defaults to global.affinity preset) | Assign custom [affinity] rules to the deployment |
| worker.autoscaling.behavior | object | `{}` | Configures the scaling behavior of the target in both Up and Down directions. |
| worker.autoscaling.enabled | bool | `true` | Enable Horizontal Pod Autoscaler ([HPA]) for the worker |
| worker.autoscaling.maxReplicas | int | `5` | Maximum number of replicas for the worker [HPA] |
| worker.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the worker [HPA] |
| worker.autoscaling.scaleTargetRef | object | `{"apiVersion":"apps/v1","kind":"Deployment","name":"application-template-worker"}` | scaleTargetRef.name is same value with worker.name |
| worker.autoscaling.targetCPUUtilizationPercentage | int | `80` | If targetCPUUtilizationPercentage is set to 0, the autoscaler will not take CPU metrics into consideration while calculating the number of replicas. |
| worker.autoscaling.targetMemoryUtilizationPercentage | int | `0` | If targetMemoryUtilizationPercentage is set to 0, the autoscaler will not take memory metrics into consideration while calculating the number of replicas. |
| worker.deploymentAnnotations | object | `{}` | Annotations to be added to worker Deployment |
| worker.deploymentStrategy | object | `{}` | Deployment strategy to be added to the worker Deployment |
| worker.enabled | bool | `false` |  |
| worker.envFrom | list | `[]` | envfrom in worker deployment |
| worker.extraArgs | list | `[]` | Additional command line arguments to pass to worker |
| worker.extraCommands | list | `[]` | Additional command line arguments to pass to worker |
| worker.extraConfigMaps | list | `[]` | Additional configMaps to pass to worker |
| worker.extraEnvs | list | `[]` | extra envs to pass to worker |
| worker.extraSecrets | list | `[]` | extra secrets to pass to worker |
| worker.image.hub | string | `""` | hub applied to worker deployments |
| worker.image.imagePullPolicy | string | `""` | imagePullPolicy applied to worker deployments |
| worker.image.repository | string | `""` | repository applied to worker deployments |
| worker.image.tag | string | `""` | global image tag |
| worker.initContainers | list | `[]` | Init containers to add to the application worker pod |
| worker.istio.destinationRules | list | `[]` | destinationRule configuration |
| worker.istio.enabled | bool | `false` | Create istio resources |
| worker.istio.ingressGateways | list | `[]` | ingress gateway configuration |
| worker.istio.virtualServices | list | `[]` | virtualService configuration |
| worker.lifecycle | object | `{}` | Specify postStart and preStop lifecycle hooks for your container |
| worker.name | string | `"application-template-worker"` | worker name |
| worker.nodeSelector | object | `{}` (defaults to global.nodeSelector) | [Node selector] |
| worker.pdb.annotations | object | `{}` | Annotations to be added to worker pdb |
| worker.pdb.enabled | bool | `false` | Deploy a [PodDisruptionBudget] for the worker |
| worker.pdb.labels | object | `{}` | Labels to be added to worker pdb |
| worker.pdb.maxUnavailable | string | `""` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%). # Has higher precedence over `worker.pdb.minAvailable` |
| worker.pdb.minAvailable | string | `""` (defaults to 0 if not specified) | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| worker.podAnnotations | object | `{}` | Annotations to be added to worker pods |
| worker.podLabels | object | `{}` | Labels to be added to worker pods |
| worker.ports[0].name | string | `"http"` |  |
| worker.ports[0].port | int | `80` |  |
| worker.ports[0].targetPort | int | `3000` |  |
| worker.replicas | int | `1` | The number of worker pods to run |
| worker.resources | object | `{}` | Resource limits and requests for the worker |
| worker.rolloutAnalysis | object | `{}` | Rollout analysis to be added to the worker Rollout |
| worker.serviceAccount.annotations | object | `{}` | Annotations applied to created service account |
| worker.serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials for the Service Account |
| worker.serviceAccount.create | bool | `true` | Create global service account |
| worker.serviceAccount.imagePullSecrets | list | `[]` | Image pull Secrets for the Service Account |
| worker.serviceAccount.labels | object | `{}` | Labels applied to created service account |
| worker.serviceAccount.name | string | `"application-template-worker"` | Server service account name |
| worker.terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds for container lifecycle hook |
| worker.tolerations | list | `[]` (defaults to global.tolerations) | [Tolerations] for use with node taints |
| worker.topologySpreadConstraints | list | `[]` (defaults to global.topologySpreadConstraints) | Assign custom [TopologySpreadConstraints] rules to the worker # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # If labelSelector is left out, it will default to the labelSelector configuration of the deployment |
| worker.volumeMounts | list | `[]` | Additional volumeMounts to the application worker main container |
| worker.volumes | list | `[]` | Additional volumes to the application worker pod |
| worker.workload | string | `"deployment"` | set deployment kind to Rollouts rollout:   enabled : false |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
