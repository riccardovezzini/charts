{{- define "searxng.persistence" -}}
persistence:
  config:
    enabled: true
    {{- include "searxng.storage.migration" (dict "storage" .Values.searxngStorage.config) }}
    {{- include "ix.v1.common.app.storageOptions" (dict "storage" .Values.searxngStorage.config) | nindent 2 }}
    targetSelector:
      searxng:
        searxng:
          mountPath: /etc/searxng
        01-permissions:
          mountPath: /mnt/directories/searxng
  tmp:
    enabled: true
    type: emptyDir
    targetSelector:
      searxng:
        searxng:
          mountPath: /tmp
  {{- range $idx, $storage := .Values.searxngStorage.additionalStorages }}
  {{ printf "searxng-%v:" (int $idx) }}
    enabled: true
    {{- include "searxng.storage.migration" (dict "storage" $storage) }}
    {{- include "ix.v1.common.app.storageOptions" (dict "storage" $storage) | nindent 2 }}
    targetSelector:
      searxng:
        searxng:
          mountPath: {{ $storage.mountPath }}
  {{- end }}
{{- end -}}

{{- define "searxng.storage.migration" -}}
  {{- $storage := .storage -}}

  {{- if $storage.hostPath -}}
    {{- $_ := set $storage "hostPathConfig" dict -}}
    {{- $_ := set $storage.hostPathConfig.hostPath $storage.hostPath -}}
  {{- end -}}
{{- end -}}
