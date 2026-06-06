{{/*
Bridge templates for parent charts to pass their own .Files context.

When app-template is used as a subchart (dependency), Helm's .Files scoping
prevents configMapsFromFolder/secretsFromFolder from reading files in the
parent chart's directory. These templates work around this by accepting
the parent chart's .Files explicitly while using app-template's root context
for template operations (values, name resolution, etc.).

IMPORTANT: The parent chart MUST leave configMapsFromFolder.enabled = false
(or unset) in its values.yaml under app-template:. Setting it to true at the
subchart level would trigger the default rendering path which fails because
app-template's .Files cannot see the parent chart's config/ directory.

Usage in parent chart template:
  {{ include "app-template.configmaps-from-folder" (dict
    "files" $.Files
    "configMapsFromFolder" (dict
      "enabled" true
      "basePath" "config/my-app"
    )
  ) }}

The configMapsFromFolder/secretsFromFolder dicts can be passed as arguments
to the bridge template. If omitted, they default to disabled.
*/}}
{{- define "app-template.configmaps-from-folder" -}}
  {{- $files := .files -}}
  {{- $mergedConfig := mergeOverwrite (dict "enabled" false) ($.Values.configMapsFromFolder | default dict) (.configMapsFromFolder | default dict) -}}
  {{- $valuesCopy := deepCopy $.Values -}}
  {{- $_ := set $valuesCopy "configMapsFromFolder" $mergedConfig -}}
  {{- $overriddenRootCtx := dict "Values" $valuesCopy "Chart" $.Chart "Release" $.Release -}}
  {{- include "bjw-s.common.render.configMaps.fromFolder" (dict "rootContext" $overriddenRootCtx "files" $files) -}}
{{- end -}}

{{/*
Same as above, but for secretsFromFolder.
*/}}
{{- define "app-template.secrets-from-folder" -}}
  {{- $files := .files -}}
  {{- $mergedConfig := mergeOverwrite (dict "enabled" false) ($.Values.secretsFromFolder | default dict) (.secretsFromFolder | default dict) -}}
  {{- $valuesCopy := deepCopy $.Values -}}
  {{- $_ := set $valuesCopy "secretsFromFolder" $mergedConfig -}}
  {{- $overriddenRootCtx := dict "Values" $valuesCopy "Chart" $.Chart "Release" $.Release -}}
  {{- include "bjw-s.common.render.secrets.fromFolder" (dict "rootContext" $overriddenRootCtx "files" $files) -}}
{{- end -}}
