{{- define "demo.items" -}}
{{- $cm := lookup "v1" "ConfigMap" "demo-system" .Release.Name -}}
{{- if and $cm $cm.data (index $cm.data "items") -}}
{"items": {{ $cm.data.items }}}
{{- else -}}
{"items": []}
{{- end -}}
{{- end -}}
