{{/*
Expand the name of the chart.
*/}}
{{- define "application.name" -}}
{{-  .Values.server.name | default (printf "%s-%s" .Release.Name "server") | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "application.server.name" -}}
{{- .Values.server.name | default (printf "%s-%s" .Release.Name "server") | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "application.worker.name" -}}
{{- .Values.worker.name | default (printf "%s-%s" .Release.Name "worker") | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "application.scheduler.name" -}}
{{- .Values.scheduler.name | default (printf "%s-%s" .Release.Name "scheduler" ) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "application.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
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
app.kubernetes.io/env: {{ .Values.global.runtimeEnv | default "stage" }}
env: {{ .Values.global.env | default "stage" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- if .Values.global.observability.datadog.admissionController.enabled }}
tags.datadoghq.com/env: {{ .Values.global.env.DD_ENV | .Values.global.runtimeEnv | default "stage" }}
tags.datadoghq.com/service: {{ .Release.Name }}
tags.datadoghq.com/version: {{ .Values.global.image.tag | quote }}
{{- end }}
{{- with .Values.global.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Each Component labels
*/}}
{{- define "application.server.labels" -}}
{{ include "application.commonLabels" . }}
app.kubernetes.io/name: {{ include "application.server.name" . }}
app.kubernetes.io/version: {{ include "application.server.image.tag" . }}
app.kubernetes.io/component: server

{{- end }}

{{- define "application.scheduler.labels" -}}
{{ include "application.commonLabels" . }}
app.kubernetes.io/name: {{ include "application.scheduler.name" . }}
app.kubernetes.io/version: {{ include "application.scheduler.image.tag" . }}
app.kubernetes.io/component: scheduler
{{- end }}

{{- define "application.worker.labels" -}}
{{ include "application.commonLabels" . }}
app.kubernetes.io/name: {{ include "application.worker.name" . }}
app.kubernetes.io/version: {{ include "application.worker.image.tag" . }}
app.kubernetes.io/component: worker
{{- end }}


{{/*
Image tags(version)
*/}}
{{- define "application.server.image.tag" -}}
{{ .Values.server.image.tag | default .Values.global.image.tag }}
{{- end }}

{{- define "application.scheduler.image.tag" -}}
{{ .Values.scheduler.image.tag | default .Values.global.image.tag }}
{{- end }}

{{- define "application.worker.image.tag" -}}
{{ .Values.worker.image.tag | default .Values.global.image.tag }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "application.server.selectorLabels" -}}
app: {{ include "application.server.name" . }}
version:  {{ include "application.server.image.tag" . }}
{{- end }}

{{- define "application.scheduler.selectorLabels" -}}
app: {{ include "application.scheduler.name" . }}
version: {{ include "application.scheduler.image.tag" . }}
{{- end }}

{{- define "application.worker.selectorLabels" -}}
app: {{ include "application.worker.name" . }}
version: {{ include "application.worker.image.tag" . }}
{{- end }}


{{/*
matchLabels labels
*/}}
{{- define "application.server.matchLabels" -}}
app: {{ (.Values.server.name | default .Chart.Name )| lower}}
version: {{ .Chart.Version }}
{{- end }}

{{- define "application.scheduler.matchLabels" -}}
app: {{ (.Values.scheduler.name | default .Chart.Name )| lower}}
version: {{ .Chart.Version | quote }}
{{- end }}

{{- define "application.worker.matchLabels" -}}
app: {{ (.Values.worker.name | default .Chart.Name )| lower}}
version: {{ .Chart.Version | quote }}
{{- end }}


{{/*
Create the name of the controller service account to use
*/}}
{{- define "server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create -}}
    {{ default ( .Values.server.name ) .Values.server.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.server.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the controller service account to use
*/}}
{{- define "worker.serviceAccountName" -}}
{{- if .Values.worker.serviceAccount.create -}}
    {{ default ( .Values.worker.name ) .Values.worker.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.worker.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the controller service account to use
*/}}
{{- define "scheduler.serviceAccountName" -}}
{{- if .Values.scheduler.serviceAccount.create -}}
    {{ default ( .Values.scheduler.name ) .Values.scheduler.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.scheduler.serviceAccount.name }}
{{- end -}}
{{- end -}}
