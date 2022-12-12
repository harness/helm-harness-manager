{{/*
Expand the name of the chart.
*/}}
{{- define "harness-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "harness-manager.fullname" -}}
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
{{- define "harness-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "harness-manager.labels" -}}
helm.sh/chart: {{ include "harness-manager.chart" . }}
{{ include "harness-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "harness-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "harness-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "harness-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "harness-manager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the delegate image to use
*/}}
{{- define "harness-manager.delegate_docker_image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.delegate_docker_image.image "global" .Values.global) }}
{{- end }}

{{/*
Create the name of the immutable delegate image to use
*/}}
{{- define "harness-manager.immutable_delegate_docker_image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.immutable_delegate_docker_image.image "global" .Values.global) }}
{{- end }}

{{/*
Create the name of the delegate upgrader image to use
*/}}
{{- define "harness-manager.upgrader_docker_image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.upgrader_docker_image.image "global" .Values.global) }}
{{- end }}


## Generate ffString based of feature flag values and globally enabled features
{{- define "harness-manager.ffString" -}}
{{- $flags := .Values.featureFlags.Base }}
{{- if .Values.global.gitops.enabled }}
{{- $flags = printf "%s,%s" $flags $.Values.featureFlags.GitOps }}
{{- end }}
{{- if .Values.global.opa.enabled }}
{{- $flags = printf "%s,%s" $flags $.Values.featureFlags.OPA }}
{{- end }}
{{- if .Values.global.cd.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CD }}
{{- end }}
{{- if .Values.global.ci.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CI }}
{{- end }}
{{- if .Values.global.sto.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.STO }}
{{- end }}
{{- if .Values.global.srm.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.SRM }}
{{- end }}
{{- if .Values.global.ngcustomdashboard.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CDB }}
{{- end }}
{{- if .Values.global.ff.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.FF }}
{{- end }}
{{- if .Values.global.ccm.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.CCM }}
{{- end }}
{{- if .Values.global.saml.autoaccept }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.SAMLAutoAccept }}
{{- end }}
{{- if .Values.global.license.enabled }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.LICENSE }}
{{- end }}
{{- $flags = printf "%s,%s" $flags .Values.featureFlags.ADD }}
{{- printf "%s" $flags }}
{{- end }}



{{- define "harness-manager.pullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.waitForInitContainer.image) "global" .Values.global ) }}
{{- end -}}