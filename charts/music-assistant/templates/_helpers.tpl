{{/*
Expand the name of the chart.
*/}}
{{- define "music-assistant.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "music-assistant.fullname" -}}
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
{{- define "music-assistant.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "music-assistant.labels" -}}
helm.sh/chart: {{ include "music-assistant.chart" . }}
{{ include "music-assistant.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "music-assistant.selectorLabels" -}}
app.kubernetes.io/name: {{ include "music-assistant.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "music-assistant.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "music-assistant.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
DNS policy: ClusterFirstWithHostNet on the host network so Service names keep resolving
*/}}
{{- define "music-assistant.dnsPolicy" -}}
{{- if .Values.dnsPolicy }}
{{- .Values.dnsPolicy }}
{{- else if .Values.hostNetwork }}
{{- "ClusterFirstWithHostNet" }}
{{- else }}
{{- "ClusterFirst" }}
{{- end }}
{{- end }}

{{/*
Name of the /data PVC
*/}}
{{- define "music-assistant.dataClaimName" -}}
{{- .Values.persistence.data.existingClaim | default (printf "%s-data" (include "music-assistant.fullname" .)) }}
{{- end }}

{{/*
Image reference, with optional digest
*/}}
{{- define "music-assistant.image" -}}
{{- $ref := printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- with .Values.image.digest }}
{{- $ref = printf "%s@%s" $ref . }}
{{- end }}
{{- $ref }}
{{- end }}

{{/*
Metadata annotations: commonAnnotations merged with resource-specific ones.
Usage: include "music-assistant.annotations" (dict "ctx" $ "extra" .Values.foo.annotations)
Renders the whole `annotations:` key, or nothing when empty.
*/}}
{{- define "music-assistant.annotations" -}}
{{- $all := merge (deepCopy (.extra | default dict)) (.ctx.Values.commonAnnotations | default dict) }}
{{- with $all }}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
