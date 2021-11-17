{{/*
Expand the name of the chart.
*/}}
{{- define "password-pusher.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "password-pusher.fullname" -}}
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
Define base name of rds resources.
*/}}
{{- define "password-pusher.rdsResourcesName" -}}
{{- printf "%s-rdspostgresql" (include "password-pusher.name" . ) -}}
{{- end }}

{{/*
Define name of secret with RDS connection info.
*/}}
{{- define "password-pusher.databaseConnSecretName" -}}
{{- printf "%s-conn" include "password-pusher.rdsResourcesName" . }}
{{- end }}

{{/*
Define name of RDS database.
*/}}
{{- define "password-pusher.databaseName" -}}
{{- printf "%s%s" (include "password-pusher.name" .) .Values.applicationEnvironment | replace "-" "" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "password-pusher.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Format the full domain name.
*/}}
{{- define "password-pusher.domain" -}}
{{- if contains "prod" .Values.applicationEnvironment }}
{{- printf "%s.%s" (include "password-pusher.name" .) .Values.applicationSubdomain }}
{{- else }}
{{- printf "%s.%s.%s" (include "password-pusher.name" .) .Values.applicationEnvironment .Values.applicationSubdomain }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "password-pusher.labels" -}}
{{ include "password-pusher.baseLabels" . }}
app: {{ include "password-pusher.name" . }}
environment: {{ .Values.applicationEnvironment }}
helm.sh/chart: {{ include "password-pusher.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Values.version }}
tags.datadoghq.com/domain: {{ include "password-pusher.domain" . }}
tags.datadoghq.com/env: {{ .Values.applicationEnvironment }}
tags.datadoghq.com/service: {{ include "password-pusher.name" . }}
tags.datadoghq.com/version: {{ .Values.version }}
tags.updater.com/domain: {{ include "password-pusher.domain" . }}
{{- end }}

{{/* Base labels
*/}}
{{- define "password-pusher.baseLabels" -}}
app.kubernetes.io/instance: {{ include "password-pusher.name" . }}-{{ .Values.applicationEnvironment }}
app.kubernetes.io/name: {{ include "password-pusher.name" . }}
app.kubernetes.io/part-of: {{ include "password-pusher.name" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "password-pusher.selectorLabels" -}}
app.kubernetes.io/component: application
{{ include "password-pusher.baseLabels" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "password-pusher.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "password-pusher.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
