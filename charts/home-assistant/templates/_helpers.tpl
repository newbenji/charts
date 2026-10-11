{{/*
Expand the name of the chart.
*/}}
{{- define "home-assistant.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "home-assistant.fullname" -}}
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
{{- define "home-assistant.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "home-assistant.labels" -}}
helm.sh/chart: {{ include "home-assistant.chart" . }}
{{ include "home-assistant.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "home-assistant.selectorLabels" -}}
app.kubernetes.io/name: {{ include "home-assistant.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: home-assistant
{{- end }}

{{/*
Selector labels
*/}}
{{- define "home-assistant.selectorLabelsWhisper" -}}
app.kubernetes.io/name: {{ include "home-assistant.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: whisper
{{- end }}

{{/*
Whisper fullname
*/}}
{{- define "home-assistant.whisperFullname" -}}
{{- printf "%s-whisper" (include "home-assistant.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Whisper labels
*/}}
{{- define "home-assistant.labelsWhisper" -}}
helm.sh/chart: {{ include "home-assistant.chart" . }}
{{ include "home-assistant.selectorLabelsWhisper" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "home-assistant.selectorLabelsPiper" -}}
app.kubernetes.io/name: {{ include "home-assistant.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: piper
{{- end }}

{{/*
Piper fullname
*/}}
{{- define "home-assistant.piperFullname" -}}
{{- printf "%s-piper" (include "home-assistant.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Piper labels
*/}}
{{- define "home-assistant.labelsPiper" -}}
helm.sh/chart: {{ include "home-assistant.chart" . }}
{{ include "home-assistant.selectorLabelsPiper" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "home-assistant.selectorLabelsZigbee2mqtt" -}}
app.kubernetes.io/name: {{ include "home-assistant.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: zigbee2mqtt
{{- end }}

{{/*
Zigbee2mqtt fullname
*/}}
{{- define "home-assistant.zigbee2mqttFullname" -}}
{{- printf "%s-zigbee2mqtt" (include "home-assistant.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Zigbee2mqtt labels
*/}}
{{- define "home-assistant.labelsZigbee2mqtt" -}}
helm.sh/chart: {{ include "home-assistant.chart" . }}
{{ include "home-assistant.selectorLabelsZigbee2mqtt" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}




{{/*
Create the name of the service account to use
*/}}
{{- define "home-assistant.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "home-assistant.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "home-assistant.recorder-secret" -}}
hadbconfig: {{ .Values.hadbconfig | quote }}
{{ end }}

{{- define "home-assistant.recorder" -}}
{{ .Values.config.recorder | toYaml | indent 0 }}
db_url: !secret hadbconfig
{{ end }}

{{- define "home-assistant.http" -}}
{{ .Values.config.http | toYaml | indent 0 }}
{{ end }}


{{- define "home-assistant.telegram_bot" -}}
{{ .Values.config.telegram_bot | toYaml | indent 0 }}
{{ end }}


{{- define "home-assistant.notify" -}}
{{ .Values.config.notify | toYaml | indent 0 }}
{{ end }}


{{- define "home-assistant.scripts" -}}
# This file is created by the helmchart.
# See config.scripts in values.yaml
# script:
{{ .Values.config.scripts | toYaml | indent 0 }}
{{ end }}


{{- define "home-assistant.blueprints" -}}
# This file is created by the helmchart.
# See config.blueprints in values.yaml
# script:
{{ .Values.config.blueprints | toYaml | indent 0 }}
{{ end }}


{{- define "home-assistant.automations" -}}
# This file is created by the helmchart.
# See config.automations in values.yaml
# script:
{{ .Values.config.automations | toYaml | indent 0 }}
{{ end }}