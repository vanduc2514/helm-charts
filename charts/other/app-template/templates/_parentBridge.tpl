{{/*
Bridge templates for parent charts to pass their own .Files context.

When app-template is used as a subchart (dependency), Helm's .Files scoping
prevents configMapsFromFolder/secretsFromFolder from reading files in the
parent chart's directory. These templates provide a workaround by accepting
the parent chart's full context (which includes its .Files) and rendering
configMaps/secrets using that context.

Usage in parent chart:
  {{ include "app-template.configmaps-from-folder" . }}

This reads configMapsFromFolder values from the parent chart's top-level
values and uses the parent chart's .Files to read the folder contents.
Values should be at top level (NOT inside app-template: section):

  configMapsFromFolder:
    enabled: true
    basePath: config/my-app
*/}}
{{- define "app-template.configmaps-from-folder" -}}
{{- include "bjw-s.common.render.configMaps.fromFolder" (dict "rootContext" . "files" $.Files) -}}
{{- end -}}

{{/*
Same as above, but for secretsFromFolder.
*/}}
{{- define "app-template.secrets-from-folder" -}}
{{- include "bjw-s.common.render.secrets.fromFolder" (dict "rootContext" . "files" $.Files) -}}
{{- end -}}
