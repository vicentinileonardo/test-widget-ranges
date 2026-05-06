# Dynamic generation of Widgets

# Install

Install compositondefinition:
```sh
kubectl apply -f compositiondefinition.yaml
```

Install composition:
```sh
kubectl apply -f compositiond.yaml
```


## Sources of truth

either:
- in-cluster (e.g. configmaps, CRs, etc.)
- external (e.g. GitHub, Jira, etc.)

## External state retrieval and storage

1) restaction + configmap (current approach)

2) restaction + crd (if more structure is needed in the k8s resource)
crd is used as storage of the state of the external system
but who creates the CRD? 
ad hoc every time

3) read-only KOG resource (so a read-only kog controller) (set in the restdefintion only the GET action and store that state into the status of the resource, maybe careful handcrafting of the OAS is needed) 
to be checked if restdefinition is valid with only GET action and if the status subresource is properly generated (`additionalStatusFields` must be used) and at runtime the status is properly updated with the response of the GET action.
also, in this case could happen that the k8s resource we are going to create with KOG represent a list of items, so we need to check if KOG can properly handle that and update the status with the new list of items every time the GET action is called.
The status subresource is very important in this case because it allows us to store the state of the external system.
KOG still lacks rate limiting.

## Templating

Example:
```yaml
{{- $data := include "demo.items" . | fromJson }}
{{- $items := $data.items }}
apiVersion: widgets.templates.krateo.io/v1beta1
kind: Column
metadata:
  name: demo-content-col
  namespace: demo-system
spec:
  widgetData:
    allowedResources: [ panels ]
    items:
      {{- if $items }}
      {{- range $index, $item := $items }}
      - resourceRefId: demo-detail-panel-{{ $index }}
      {{- end }}
      {{- else }} []
      {{- end }}
  resourcesRefs:
    items:
      {{- if $items }}
      {{- range $index, $item := $items }}
      - id: demo-detail-panel-{{ $index }}
        apiVersion: widgets.templates.krateo.io/v1beta1
        resource: panels
        name: demo-detail-panel-{{ $index }}
        namespace: demo-system
        verb: GET
      {{- end }}
      {{- else }} []
      {{- end }}
```



---

maybe another
restaction to send a patch to trigger compositon update

              "annotations": ((.annotations // {}) + { "krateo.io/last-updated": (now | todate) })

---

