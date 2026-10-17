{{/*
Expand the name of the chart.
*/}}
{{- define "cloudflare-ddns.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloudflare-ddns.fullname" -}}
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
{{- define "cloudflare-ddns.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cloudflare-ddns.labels" -}}
helm.sh/chart: {{ include "cloudflare-ddns.chart" . }}
{{ include "cloudflare-ddns.selectorLabels" . }}
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
{{- define "cloudflare-ddns.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloudflare-ddns.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Container image reference: repo:tag, plus @digest when pinned.
*/}}
{{- define "cloudflare-ddns.image" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if .Values.image.digest -}}
{{- printf "%s:%s@%s" .Values.image.repository $tag .Values.image.digest -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end -}}
{{- end }}

{{/*
Name and key of the Secret holding the API token. Fails unless exactly one
of cloudflare.apiToken / cloudflare.existingSecret.name is set.
*/}}
{{- define "cloudflare-ddns.tokenSecretName" -}}
{{- $existing := .Values.cloudflare.existingSecret.name -}}
{{- if and $existing .Values.cloudflare.apiToken -}}
{{- fail "set either cloudflare.apiToken or cloudflare.existingSecret.name, not both" -}}
{{- else if $existing -}}
{{- $existing -}}
{{- else if .Values.cloudflare.apiToken -}}
{{- include "cloudflare-ddns.fullname" . -}}
{{- else -}}
{{- fail "a Cloudflare API token is required: set cloudflare.apiToken or cloudflare.existingSecret.name" -}}
{{- end -}}
{{- end }}

{{- define "cloudflare-ddns.tokenSecretKey" -}}
{{- if .Values.cloudflare.existingSecret.name -}}
{{- .Values.cloudflare.existingSecret.key -}}
{{- else -}}
api-token
{{- end -}}
{{- end }}

{{/*
Fails when no domain list is set at all.
*/}}
{{- define "cloudflare-ddns.validateDomains" -}}
{{- if not (or .Values.domains .Values.ip4Domains .Values.ip6Domains) -}}
{{- fail "nothing to manage: set at least one of domains, ip4Domains, ip6Domains" -}}
{{- end -}}
{{- end }}
