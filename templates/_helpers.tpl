{{/*
Expand the name of the chart.
*/}}
{{- define "campville.name" -}}
{{- printf "%s-%s" ( include "app.prefix" . ) ( .Values.env | default "production" ) ( .Chart.Name | trunc 63 | trimSuffix "-" )}}
{{- end }}

{{- define "campville.env" -}}
{{- if .Values.env }}
{{- default .Values.env }}
{{- else}}
{{- default "production" }}
{{- end }}
{{- end }}

{{- define "campville.node.role" -}}
{{- if (ne .Values.env "production")}}
{{- default "stage"}}
{{- else}}
{{- default "prod" }}
{{- end }}
{{- end }}

{{- define "campville.path.secrets" -}}
{{- printf "env/%s/secrets.yaml" ( include "campville.env" . ) }}
{{- end }}

{{- define "campville.path.config" -}}
{{- printf "env/%s/campville.yaml" ( include "campville.env" . ) }}
{{- end }}

{{- define "app.prefix" -}}
{{- if .Values.prefix }}
{{- printf "%s-" .Values.prefix }}
{{- else }}
{{- default "" }}
{{- end }}
{{- end }}

{{- define "app.name.todo" -}}
{{- printf "%s-%s" ( include "campville.name" . ) ( .Values.todo.name | default "todo" ) }}
{{- end }}

{{- define "campville.apiHost" -}}
{{- if .Values.prefix }}
{{- printf "%s-%s-%s" .Values.prefix "api" .Values.host | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" "api" .Values.host | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "campville.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "campville.labels" -}}
env: {{ include "campville.env" . }}
helm.sh/chart: {{ include "campville.chart" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "campville.selectorLabels" -}}
app.kubernetes.io/name: {{ include "campville.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}