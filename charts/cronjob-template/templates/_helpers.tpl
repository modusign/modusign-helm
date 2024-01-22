{{/*
Expand the name of the chart.
*/}}
{{- define "application.name" -}}
{{-  .Values.name | default (printf "%s-%s" .Release.Name "cronJob") | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "application.commonLabels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.modusign.co.kr/zone: {{ .Release.Namespace }}
app.kubernetes.io/env: {{ .Values.runtimeEnv | default "stage" }}
env: {{ .Values.runtimeEnv | default "stage" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- if .Values.observability.datadog.admissionController.enabled }}
tags.datadoghq.com/env: {{ .Values.env.DD_ENV | .Values.runtimeEnv | default "stage" }}
tags.datadoghq.com/service: {{ .Release.Name }}
tags.datadoghq.com/version: {{ .Values.image.tag | quote }}
{{- end }}
{{- with .Values.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Each Component labels
*/}}
{{- define "application.cronJob.labels" -}}
{{ include "application.commonLabels" . }}
app.kubernetes.io/name: {{ include "application.name" . }}
app.kubernetes.io/version: {{ include "application.cronJob.image.tag" . }}
app.kubernetes.io/component: batch
{{- end }}

{{/*
Image tags(version)
*/}}
{{- define "application.cronJob.image.tag" -}}
{{ .Values.image.tag | default "stage"}}
{{- end }}


{{/*
Create the name of the controller service account to use
*/}}
{{- define "serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default ( .Values.name ) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
