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


{{- define "home-assistant.automations" -}}
# This file is created by the helmchart.
# See config.automations in values.yaml
{{ .Values.config.automations | default list | toYaml | indent 0 }}
{{ end }}


{{/*
Renders a piece of Home Assistant YAML given either as a string (passed
through as-is) or as a map/list (via toYaml). Helm silently drops custom
YAML tags when it parses values, so in map form HA's tags must be written
quoted, e.g. db_url: "!secret hadbconfig"; this unquotes them again after
toYaml. Only HA's own tags are touched - any other "!..." string stays a
quoted string.
*/}}
{{- define "home-assistant.haYaml" -}}
{{- if kindIs "string" . -}}
{{ . }}
{{- else -}}
{{ regexReplaceAll "'(!(secret|include|include_dir_list|include_dir_named|include_dir_merge_list|include_dir_merge_named|env_var|input) [^']*)'" (toYaml .) "${1}" }}
{{- end -}}
{{- end }}


{{/*
Hash of the data in every chart-rendered config file, for the deployment's
checksum/config annotation.
*/}}
{{- define "home-assistant.configChecksum" -}}
{{- $files := list "config-http.yaml" "recorder.yaml" "configmap-scripts.yaml" "configmap-automations.yaml" "configmap-blueprints.yaml" "configmap-notify.yaml" "configmap-telegram-bot.yaml" "configmap-packages.yaml" "secret-ha-secrets.yaml" -}}
{{- if eq (include "home-assistant.configurationMode" .) "managed" }}
{{- $files = append $files "configmap-configuration.yaml" }}
{{- end -}}
{{- $out := "" -}}
{{- range $files -}}
{{- /* Only the payload: metadata carries helm.sh/chart, which would roll the pod on every chart version bump */ -}}
{{- $doc := include (print $.Template.BasePath "/" .) $ | fromYaml -}}
{{- $out = print $out (pick $doc "data" "stringData" | toJson) -}}
{{- end -}}
{{- $out | sha256sum -}}
{{- end }}


{{/*
Name of a chart-rendered config object: the release fullname plus a suffix,
so two releases in one namespace don't collide. Called with (list $ "suffix").
*/}}
{{- define "home-assistant.configName" -}}
{{- $root := index . 0 -}}
{{- printf "%s-%s" (include "home-assistant.fullname" $root) (index . 1) | trunc 63 | trimSuffix "-" -}}
{{- end }}


{{/*
Whether /config/secrets.yaml comes from a Secret (config.secrets).
*/}}
{{- define "home-assistant.secretsEnabled" -}}
{{- if or .Values.config.secrets.existingSecret .Values.config.secrets.values }}true{{ end -}}
{{- end }}

{{- define "home-assistant.secretsName" -}}
{{- .Values.config.secrets.existingSecret | default (include "home-assistant.configName" (list . "secrets")) -}}
{{- end }}


{{/*
config.configuration.mode, validated.
*/}}
{{- define "home-assistant.configurationMode" -}}
{{- $mode := .Values.config.configuration.mode | default "unmanaged" -}}
{{- if not (has $mode (list "unmanaged" "seed" "managed")) -}}
{{- fail (printf "config.configuration.mode must be unmanaged, seed or managed, not %q" $mode) -}}
{{- end -}}
{{- $mode -}}
{{- end }}

{{/*
The rendered configuration.yaml: config.configuration.content, plus a
homeassistant: block built from config.configuration.homeassistant with the
packages include added when config.packages is set. The chart owns that
block, so content defining its own homeassistant: key is rejected - HA would
fail on the duplicate key at startup instead.
*/}}
{{- define "home-assistant.configurationYaml" -}}
{{- $c := .Values.config.configuration -}}
{{- $body := include "home-assistant.haYaml" ($c.content | default "") -}}
{{- if regexMatch "(?m)^homeassistant\\s*:" $body -}}
{{- fail "config.configuration.content must not define homeassistant: - put those settings in config.configuration.homeassistant instead, which the chart merges with the packages include" -}}
{{- end -}}
{{- $ha := deepCopy ($c.homeassistant | default dict) -}}
{{- if .Values.config.packages -}}
{{- $_ := set $ha "packages" "!include_dir_named packages" -}}
{{- end -}}
# Rendered by the home-assistant Helm chart from config.configuration
# (mode: {{ include "home-assistant.configurationMode" . }}).
{{ $body | trim }}
{{- if $ha }}

{{ include "home-assistant.haYaml" (dict "homeassistant" $ha) | trim }}
{{- end }}
{{ end }}
