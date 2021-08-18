{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "regards-common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "regards-common.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "regards-common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "regards-common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "regards-common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "regards-common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "regards-common.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Create image from repository and tag as per chart version or globals
*/}}
{{- define "regards-common.image" -}}
{{- $registry := default .Values.global.regards.imageRegistry .Values.image.registry -}}
{{- $name := default (include "regards-common.name" .) .Values.image.name -}}
{{- $appVersion := required "The value global.regards.servicesVersion is required" .Values.global.regards.servicesVersion -}}
{{- $tag := default $appVersion .Values.image.tag -}}
{{- printf "%s/%s:%s" $registry $name $tag -}}
{{- end -}}


{{/*
Make "local" imagePullPolicy override global imagePullPolicy value
*/}}
{{- define "regards-common.imagePullPolicy" -}}
{{- default .Values.global.regards.imagePullPolicy .Values.image.pullPolicy -}}
{{- end -}}


{{/*
Create endpoint for regards configuration microservice
*/}}
{{- define "regards-common.configuration-endpoint" -}}
{{- $serviceHost := default .Values.global.regards.configService.host .Values.regards.configService.host -}}
{{- $servicePort := default .Values.global.regards.configService.port .Values.regards.configService.port -}}
{{- printf "http://%s:%s" $serviceHost (toString $servicePort) -}}
{{- end -}}
