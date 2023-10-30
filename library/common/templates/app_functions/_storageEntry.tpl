{{/* This is a shim generating yaml that will be passed
    to the actual templates later on the process.
    For that reason the validation is minimal as the
    actual templates will do the validation. */}}
{{/* Call this template:
{{ include "ix.v1.common.app.storageOptions" (dict "storage" $storage) }}
*/}}
{{- define "ix.v1.common.app.storageOptions" -}}
  {{- $storage := .storage -}}

  {{- $size := "" -}}
  {{- $hostPath := "" -}}
  {{- $datasetName := "" -}}
  {{- $readOnly := false -}}

  {{- if $storage.size -}}
    {{- $size = (printf "%vGi" $storage.size) -}}
  {{- end -}}

  {{- if eq $storage.type "hostPath" -}}
    {{- if not $storage.hostPathConfig -}}
      {{- fail (printf "Storage - Expected [hostPathConfig] to not be empty") -}}
    {{- end -}}

    {{- if $storage.hostPathConfig.readOnly -}}
      {{- $readOnly = true -}}
    {{- end -}}
    {{- if $storage.hostPathConfig.aclEnable -}}
      {{- $hostPath = $storage.hostPathConfig.acl.path -}}
    {{- else -}}
      {{- $hostPath = $storage.hostPathConfig.hostPath -}}
    {{- end -}}
  {{- end -}}

  {{- if eq $storage.type "ixVolume" -}}
    {{- if not $storage.ixVolumeConfig -}}
      {{- fail (printf "Storage Expected [ixVolumeConfig] to not be empty") -}}
    {{- end -}}

    {{- if $storage.ixVolumeConfig.readOnly -}}
      {{- $readOnly = true -}}
    {{- end -}}
    {{- $datasetName = $storage.ixVolumeConfig.datasetName -}}
  {{- end }}

  type: {{ $storage.type }}
  size: {{ $size }}
  hostPath: {{ $hostPath }}
  datasetName: {{ $datasetName }}
  readOnly: {{ $readOnly }}
  server: {{ $storage.server | default "" }}
  share: {{ $storage.share | default "" }}
  domain: {{ $storage.domain | default "" }}
  username: {{ $storage.username | default "" }}
  password: {{ $storage.password | default "" }}
  {{- if eq $storage.type "smb-pv-pvc" }}
  mountOptions:
    - key: noperm
  {{- end }}
{{- end -}}
