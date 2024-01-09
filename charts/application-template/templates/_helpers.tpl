{{/*
Expand the name of the chart.
*/}}
{{- define "application.name" -}}
{{- default .Chart.Name .Values.server.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "application.server.name" -}}
{{- default .Chart.Name .Values.server.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "application.worker.name" -}}
{{- default .Chart.Name .Values.worker.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "application.scheduler.name" -}}
{{- default .Chart.Name .Values.scheduler.name | trunc 63 | trimSuffix "-" }}
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
{{- define "application.labels" -}}
helm.sh/chart: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Release.Revision | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.modusign.co.kr/zone: {{ .Release.Namespace }}
{{- if .Values.global.observability.datadog.admissionController.enabled }}
tags.datadoghq.com/env: {{ default "stage" .Values.global.env.DD_ENV}}
tags.datadoghq.com/service: {{ .Release.Name }}
tags.datadoghq.com/version: {{ .Release.Revision | quote }}
{{- end }}
{{- with .Values.global.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "application.server.selectorLabels" -}}
app: {{ (.Values.server.name | default .Chart.Name )| lower}}
version: {{ .Chart.Version }}
{{- end }}

{{- define "application.scheduler.selectorLabels" -}}
app: {{ (.Values.scheduler.name | default .Chart.Name )| lower}}
version: {{ .Chart.Version | quote }}
{{- end }}

{{- define "application.worker.selectorLabels" -}}
app: {{ (.Values.worker.name | default .Chart.Name )| lower}}
version: {{ .Chart.Version | quote }}
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
