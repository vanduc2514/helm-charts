{{/*
Bridge templates for parent charts to pass their own .Files context.

When app-template is used as a subchart (dependency), Helm's .Files scoping
prevents configMapsFromFolder/secretsFromFolder from reading files in the
parent chart's directory. These templates provide a workaround by accepting
the parent chart's full context (which includes its .Files) and rendering
configMaps/secrets using that context.

Usage in parent chart template:
  {{ include "app-template.configmaps-from-folder" (dict "files" $.Files) }}

This uses app-template's own root context for template/dict operations
but overrides .Files with the parent chart's .Files to read config/ folder
contents. Values MUST be in the app-template: section of the parent chart:

  app-template:
    configMapsFromFolder:
      enabled: true
      basePath: config/my-app
*/}}
{{- define "app-template.configmaps-from-folder" -}}
{{- include "bjw-s.common.render.configMaps.fromFolder" (dict "rootContext" $ "files" .files) -}}
{{- end -}}

{{/*
Same as above, but for secretsFromFolder.
*/}}
{{- define "app-template.secrets-from-folder" -}}
{{- include "bjw-s.common.render.secrets.fromFolder" (dict "rootContext" $ "files" .files) -}}
{{- end -}}
