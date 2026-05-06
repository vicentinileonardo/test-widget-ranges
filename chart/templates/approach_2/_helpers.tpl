{{- define "kog.items" -}}
{{- $crd := lookup "apiextensions.k8s.io/v1" "CustomResourceDefinition" "" "branchlists.branches.demo.krateo.io" -}}
{{- if $crd -}}
{{- $bl := lookup "branches.demo.krateo.io/v1alpha1" "BranchList" "demo-system" "demo-branch-list" -}}
{{- if and $bl $bl.status (index $bl.status "branches") -}}
{"items": {{ $bl.status.branches | toJson }}}
{{- else -}}
{"items": []}
{{- end -}}
{{- else -}}
{"items": []}
{{- end -}}
{{- end -}}
