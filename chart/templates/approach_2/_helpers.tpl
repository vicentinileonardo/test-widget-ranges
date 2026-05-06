{{- define "kog.items" -}}
{{- $bl := lookup "branches.demo.krateo.io/v1alpha1" "BranchList" "demo-system" "demo-branch-list" -}}
{{- if and $bl $bl.status (index $bl.status "branches") -}}
{"items": {{ $bl.status.branches | toJson }}}
{{- else -}}
{"items": []}
{{- end -}}
{{- end -}}
