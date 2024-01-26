{{/*
Check for HTTP port
*/}}
{{- define "chart.checkHttpPort" -}}
  {{- $httpPortFound := false -}}
  {{- range .Values.service.ports -}}
    {{- if eq .name "http" -}}
      {{- $httpPortFound = true -}}
    {{- end -}}
  {{- end -}}

  {{- if (not $httpPortFound) -}}
     {{- fail "Error: Ingress is enabled, but no HTTP port named 'http' found in service.ports." -}}
  {{- end -}}
{{- end -}}
