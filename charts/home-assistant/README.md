
# Home Assistant

HomeAssistant is an open source home automation that puts local control and privacy first.
Powered by a worldwide community of tinkerers and DIY enthusiasts.
Perfect to run on a Raspberry Pi or a local server..

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2026.8.0](https://img.shields.io/badge/AppVersion-2026.8.0-informational?style=flat-square)

## Installing the Chart

This chart is published two ways: as a classic Helm repo via GitHub Pages
(releases only), and as an OCI artifact via the GitHub Container Registry
(releases and alpha builds).

Via the classic repo:

```console
$ helm repo add newbenji-charts https://newbenji.github.io/charts/
$ helm repo update
$ helm install my-release newbenji-charts/home-assistant --version 0.3.0
```

Via OCI:

```console
$ helm install my-release oci://ghcr.io/newbenji/charts/home-assistant --version 0.3.0
```

To just download the chart package:

```console
$ helm pull oci://ghcr.io/newbenji/charts/home-assistant --version 0.3.0
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config.automations | object | `{}` | Rendered into configmap-automations.yaml as Home Assistant's automations.yaml. See https://www.home-assistant.io/docs/automation/yaml/ |
| config.blueprints | object | `{}` | Rendered into configmap-blueprints.yaml as Home Assistant blueprints. See https://www.home-assistant.io/docs/automation/using_blueprints/ |
| config.http.ip_ban_enabled | bool | `false` | Ban IPs after too many failed login attempts |
| config.http.login_attempts_threshold | int | `5` | Number of failed login attempts before an IP is banned |
| config.http.trusted_proxies | list | `[]` | CIDR ranges of reverse proxies trusted to set X-Forwarded-For/X-Forwarded-Proto |
| config.http.use_x_forwarded_for | bool | `false` | Trust the X-Forwarded-For header from trusted_proxies. See https://www.home-assistant.io/integrations/http/ |
| config.notify | list | `[]` | Rendered into configmap-notify.yaml as Home Assistant's notify platform config |
| config.recorder.purge_keep_days | int | `30` | Number of days of history to keep in the recorder database. See https://www.home-assistant.io/integrations/recorder/ |
| config.scripts | object | `{}` | Rendered into configmap-scripts.yaml as Home Assistant's scripts.yaml. See https://www.home-assistant.io/docs/scripts/ |
| config.telegram_bot | list | `[]` | Rendered into configmap-telegram-bot.yaml as Home Assistant's telegram_bot platform config |
| dnsPolicy | string | `"ClusterFirstWithHostNet"` | Dns policy |
| extraContainerPorts | list | `[]` | Additional ports to open on the Home Assistant container, e.g. for integrations that listen on their own port (ESPHome dashboard, Matter, HomeKit Bridge, etc). Set `count` greater than 1 to open a contiguous range starting at containerPort. Port names must stay within Kubernetes' 15-character limit and be unique |
| extraManifests | list | `[]` | Additional arbitrary Kubernetes manifests to render alongside the chart, e.g. an ExternalSecret or a NetworkPolicy. Each entry is either a map (rendered via toYaml) or a string (rendered as-is); both are passed through tpl, so release/values templating works inside them |
| fullnameOverride | string | `""` |  |
| hadbconfig | string | `""` | Recorder database connection string, written into secrets.yaml as `hadbconfig` and referenced by config.recorder's db_url. Must be set to a real connection string. |
| homeAssistant.persistence.volumeName | string | `""` | Bind the PVC to a specific pre-provisioned PersistentVolume by name. Leave empty to let the cluster's default provisioner handle it. |
| hostNetwork | bool | `true` | Enables host networking (so that home assistant can scan devices automatically on the same network). If set to false, you might want to amend dnsPolicy value as well |
| httpRoute.annotations | object | `{}` | Annotations to add to the HTTPRoute |
| httpRoute.enabled | bool | `false` | Expose Home Assistant via a Gateway API HTTPRoute instead of an Ingress. Requires the Gateway API CRDs and a Gateway to already exist in the cluster. Mutually exclusive with ingress.enabled |
| httpRoute.hostnames | list | `[]` | Hostnames the route matches. Leave empty to match all hostnames on the parent Gateway listener(s) |
| httpRoute.labels | object | `{}` | Additional labels to add to the HTTPRoute |
| httpRoute.matches | list | `[{"path":"/","pathType":"PathPrefix"}]` | Path matches routed to the Home Assistant service |
| httpRoute.parentRefs | list | `[{"name":""}]` | References to the Gateway(s) this route attaches to |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"homeassistant/home-assistant"` | Home Assistant image repository |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` | Annotations to add to the Ingress, e.g. ingress-controller-specific annotations such as nginx.ingress.kubernetes.io/* |
| ingress.className | string | `""` | IngressClass to use, e.g. "nginx". Leave empty to use the cluster's default IngressClass |
| ingress.enabled | bool | `false` | Expose Home Assistant via a classic Ingress resource. Mutually exclusive with httpRoute.enabled |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | Host/path rules routed to the Home Assistant service |
| ingress.tls | list | `[]` | TLS configuration for the Ingress |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the Home Assistant config PVC |
| persistence.additionalMounts | list | `[]` | Additional volume mounts to add to the Home Assistant container |
| persistence.additionalVolumes | list | `[]` | Additional volumes to add to the Home Assistant pod |
| persistence.enabled | bool | `true` | Enable persistence for the Home Assistant config directory |
| persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one. Leave empty to let the chart create it |
| persistence.size | string | `"5Gi"` | Size of the Home Assistant config PVC |
| persistence.storageClass | string | `""` | StorageClass to request for the Home Assistant config PVC. Leave empty to use the cluster's default StorageClass |
| piper.enabled | bool | `false` | Deploy a wyoming-piper text-to-speech service alongside Home Assistant. Add it in Home Assistant via Settings > Devices & Services > Add Integration > Wyoming Protocol, pointing at the piper Service on its port |
| piper.extraArgs | list | `[]` | Additional command-line arguments passed to wyoming-piper |
| piper.image.pullPolicy | string | `"IfNotPresent"` | wyoming-piper image pull policy |
| piper.image.repository | string | `"rhasspy/wyoming-piper"` | wyoming-piper image repository |
| piper.image.tag | string | `"2.3.1"` | wyoming-piper image tag |
| piper.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the piper PVC |
| piper.persistence.enabled | bool | `true` | Persist the piper voice cache across restarts |
| piper.persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one. Leave empty to let the chart create it |
| piper.persistence.size | string | `"1Gi"` | Size of the piper PVC |
| piper.persistence.storageClass | string | `""` | StorageClass to request for the piper PVC. Leave empty to use the cluster's default StorageClass |
| piper.podAnnotations | object | `{}` | Annotations to add to the piper pod |
| piper.resources | object | `{}` | Resource requests/limits for the piper container |
| piper.service.port | int | `10200` | piper service port |
| piper.service.type | string | `"ClusterIP"` | Kubernetes Service type used to expose piper |
| piper.voice | string | `"en_US-lessac-medium"` | Piper voice to load, e.g. en_US-lessac-medium. See https://github.com/rhasspy/piper/blob/master/VOICES.md |
| podAnnotations | object | `{}` | Annotations to add to the Home Assistant pod |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `8123` | Service port. Also used as the backend port by the ingress and httpRoute |
| service.type | string | `"ClusterIP"` | Kubernetes Service type used to expose Home Assistant |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| strategy | string | `"RollingUpdate"` |  |
| tolerations | list | `[]` |  |
| vscode.enabled | bool | `false` | Run a code-server (VS Code in the browser) sidecar, in the same pod, for editing the Home Assistant config directory |
| vscode.extraEnv | object | `{}` | Additional environment variables for the code-server container |
| vscode.hassConfig | string | `"/config"` | Path to the Home Assistant config directory, mounted into the code-server container |
| vscode.image.pullPolicy | string | `"IfNotPresent"` | code-server image pull policy |
| vscode.image.repository | string | `"codercom/code-server"` | code-server image repository |
| vscode.image.tag | string | `"4.131.0"` | code-server image tag |
| vscode.password | string | `""` | Password to require for code-server, stored in a Secret. Leave empty to disable auth (--auth=none) — only safe if the service isn't exposed outside the cluster |
| vscode.resources | object | `{}` | Resource requests/limits for the code-server container |
| vscode.service.nodePort | string | `""` | NodePort to request for the code-server port, when service.type (the shared Service's type) is NodePort |
| vscode.service.port | int | `8080` | code-server service port, exposed alongside the main Home Assistant port on the same Service. Also used as the container's listen port, so it must be >1024 since the image runs as a non-root user |
| vscode.vscodePath | string | `"/config/.vscode"` | Path to code-server's own settings/extensions directory, inside hassConfig |
| whisper.enabled | bool | `false` | Deploy a wyoming-whisper speech-to-text service alongside Home Assistant. Add it in Home Assistant via Settings > Devices & Services > Add Integration > Wyoming Protocol, pointing at the whisper Service on its port |
| whisper.extraArgs | list | `[]` | Additional command-line arguments passed to wyoming-whisper |
| whisper.image.pullPolicy | string | `"IfNotPresent"` | wyoming-whisper image pull policy |
| whisper.image.repository | string | `"rhasspy/wyoming-whisper"` | wyoming-whisper image repository |
| whisper.image.tag | string | `"3.5.0"` | wyoming-whisper image tag |
| whisper.model | string | `"small"` | Whisper model to load. See https://github.com/rhasspy/wyoming-whisper#models |
| whisper.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the whisper PVC |
| whisper.persistence.enabled | bool | `true` | Persist the whisper model cache across restarts |
| whisper.persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one. Leave empty to let the chart create it |
| whisper.persistence.size | string | `"2Gi"` | Size of the whisper PVC |
| whisper.persistence.storageClass | string | `""` | StorageClass to request for the whisper PVC. Leave empty to use the cluster's default StorageClass |
| whisper.podAnnotations | object | `{}` | Annotations to add to the whisper pod |
| whisper.resources | object | `{}` | Resource requests/limits for the whisper container |
| whisper.service.port | int | `10300` | whisper service port |
| whisper.service.type | string | `"ClusterIP"` | Kubernetes Service type used to expose whisper |

## Values

<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>affinity</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>config.automations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Rendered into configmap-automations.yaml as Home Assistant's automations.yaml. See https://www.home-assistant.io/docs/automation/yaml/</td>
		</tr>
		<tr>
			<td>config.blueprints</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Rendered into configmap-blueprints.yaml as Home Assistant blueprints. See https://www.home-assistant.io/docs/automation/using_blueprints/</td>
		</tr>
		<tr>
			<td>config.http.ip_ban_enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Ban IPs after too many failed login attempts</td>
		</tr>
		<tr>
			<td>config.http.login_attempts_threshold</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Number of failed login attempts before an IP is banned</td>
		</tr>
		<tr>
			<td>config.http.trusted_proxies</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>CIDR ranges of reverse proxies trusted to set X-Forwarded-For/X-Forwarded-Proto</td>
		</tr>
		<tr>
			<td>config.http.use_x_forwarded_for</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Trust the X-Forwarded-For header from trusted_proxies. See https://www.home-assistant.io/integrations/http/</td>
		</tr>
		<tr>
			<td>config.notify</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Rendered into configmap-notify.yaml as Home Assistant's notify platform config</td>
		</tr>
		<tr>
			<td>config.recorder.purge_keep_days</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td>Number of days of history to keep in the recorder database. See https://www.home-assistant.io/integrations/recorder/</td>
		</tr>
		<tr>
			<td>config.scripts</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Rendered into configmap-scripts.yaml as Home Assistant's scripts.yaml. See https://www.home-assistant.io/docs/scripts/</td>
		</tr>
		<tr>
			<td>config.telegram_bot</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Rendered into configmap-telegram-bot.yaml as Home Assistant's telegram_bot platform config</td>
		</tr>
		<tr>
			<td>dnsPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterFirstWithHostNet"
</pre>
</td>
			<td>Dns policy</td>
		</tr>
		<tr>
			<td>extraContainerPorts</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Additional ports to open on the Home Assistant container, e.g. for integrations that listen on their own port (ESPHome dashboard, Matter, HomeKit Bridge, etc). Set `count` greater than 1 to open a contiguous range starting at containerPort. Port names must stay within Kubernetes' 15-character limit and be unique</td>
		</tr>
		<tr>
			<td>extraManifests</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Additional arbitrary Kubernetes manifests to render alongside the chart, e.g. an ExternalSecret or a NetworkPolicy. Each entry is either a map (rendered via toYaml) or a string (rendered as-is); both are passed through tpl, so release/values templating works inside them</td>
		</tr>
		<tr>
			<td>fullnameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>hadbconfig</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Recorder database connection string, written into secrets.yaml as `hadbconfig` and referenced by config.recorder's db_url. Must be set to a real connection string.</td>
		</tr>
		<tr>
			<td>homeAssistant.persistence.volumeName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Bind the PVC to a specific pre-provisioned PersistentVolume by name. Leave empty to let the cluster's default provisioner handle it.</td>
		</tr>
		<tr>
			<td>hostNetwork</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enables host networking (so that home assistant can scan devices automatically on the same network). If set to false, you might want to amend dnsPolicy value as well</td>
		</tr>
		<tr>
			<td>httpRoute.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Annotations to add to the HTTPRoute</td>
		</tr>
		<tr>
			<td>httpRoute.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Expose Home Assistant via a Gateway API HTTPRoute instead of an Ingress. Requires the Gateway API CRDs and a Gateway to already exist in the cluster. Mutually exclusive with ingress.enabled</td>
		</tr>
		<tr>
			<td>httpRoute.hostnames</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Hostnames the route matches. Leave empty to match all hostnames on the parent Gateway listener(s)</td>
		</tr>
		<tr>
			<td>httpRoute.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Additional labels to add to the HTTPRoute</td>
		</tr>
		<tr>
			<td>httpRoute.matches</td>
			<td>list</td>
			<td><pre lang="json">
[
  {
    "path": "/",
    "pathType": "PathPrefix"
  }
]
</pre>
</td>
			<td>Path matches routed to the Home Assistant service</td>
		</tr>
		<tr>
			<td>httpRoute.parentRefs</td>
			<td>list</td>
			<td><pre lang="json">
[
  {
    "name": ""
  }
]
</pre>
</td>
			<td>References to the Gateway(s) this route attaches to</td>
		</tr>
		<tr>
			<td>image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td>Image pull policy</td>
		</tr>
		<tr>
			<td>image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"homeassistant/home-assistant"
</pre>
</td>
			<td>Home Assistant image repository</td>
		</tr>
		<tr>
			<td>image.tag</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Overrides the image tag whose default is the chart appVersion.</td>
		</tr>
		<tr>
			<td>imagePullSecrets</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Annotations to add to the Ingress, e.g. ingress-controller-specific annotations such as nginx.ingress.kubernetes.io/*</td>
		</tr>
		<tr>
			<td>ingress.className</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>IngressClass to use, e.g. "nginx". Leave empty to use the cluster's default IngressClass</td>
		</tr>
		<tr>
			<td>ingress.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Expose Home Assistant via a classic Ingress resource. Mutually exclusive with httpRoute.enabled</td>
		</tr>
		<tr>
			<td>ingress.hosts</td>
			<td>list</td>
			<td><pre lang="json">
[
  {
    "host": "chart-example.local",
    "paths": [
      {
        "path": "/",
        "pathType": "ImplementationSpecific"
      }
    ]
  }
]
</pre>
</td>
			<td>Host/path rules routed to the Home Assistant service</td>
		</tr>
		<tr>
			<td>ingress.tls</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>TLS configuration for the Ingress</td>
		</tr>
		<tr>
			<td>nameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>nodeSelector</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.accessMode</td>
			<td>string</td>
			<td><pre lang="json">
"ReadWriteOnce"
</pre>
</td>
			<td>Access mode for the Home Assistant config PVC</td>
		</tr>
		<tr>
			<td>persistence.additionalMounts</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Additional volume mounts to add to the Home Assistant container</td>
		</tr>
		<tr>
			<td>persistence.additionalVolumes</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Additional volumes to add to the Home Assistant pod</td>
		</tr>
		<tr>
			<td>persistence.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable persistence for the Home Assistant config directory</td>
		</tr>
		<tr>
			<td>persistence.existingClaim</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Use an existing PVC instead of creating one. Leave empty to let the chart create it</td>
		</tr>
		<tr>
			<td>persistence.size</td>
			<td>string</td>
			<td><pre lang="json">
"5Gi"
</pre>
</td>
			<td>Size of the Home Assistant config PVC</td>
		</tr>
		<tr>
			<td>persistence.storageClass</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>StorageClass to request for the Home Assistant config PVC. Leave empty to use the cluster's default StorageClass</td>
		</tr>
		<tr>
			<td>piper.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Deploy a wyoming-piper text-to-speech service alongside Home Assistant. Add it in Home Assistant via Settings > Devices & Services > Add Integration > Wyoming Protocol, pointing at the piper Service on its port</td>
		</tr>
		<tr>
			<td>piper.extraArgs</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Additional command-line arguments passed to wyoming-piper</td>
		</tr>
		<tr>
			<td>piper.image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td>wyoming-piper image pull policy</td>
		</tr>
		<tr>
			<td>piper.image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"rhasspy/wyoming-piper"
</pre>
</td>
			<td>wyoming-piper image repository</td>
		</tr>
		<tr>
			<td>piper.image.tag</td>
			<td>string</td>
			<td><pre lang="json">
"2.3.1"
</pre>
</td>
			<td>wyoming-piper image tag</td>
		</tr>
		<tr>
			<td>piper.persistence.accessMode</td>
			<td>string</td>
			<td><pre lang="json">
"ReadWriteOnce"
</pre>
</td>
			<td>Access mode for the piper PVC</td>
		</tr>
		<tr>
			<td>piper.persistence.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Persist the piper voice cache across restarts</td>
		</tr>
		<tr>
			<td>piper.persistence.existingClaim</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Use an existing PVC instead of creating one. Leave empty to let the chart create it</td>
		</tr>
		<tr>
			<td>piper.persistence.size</td>
			<td>string</td>
			<td><pre lang="json">
"1Gi"
</pre>
</td>
			<td>Size of the piper PVC</td>
		</tr>
		<tr>
			<td>piper.persistence.storageClass</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>StorageClass to request for the piper PVC. Leave empty to use the cluster's default StorageClass</td>
		</tr>
		<tr>
			<td>piper.podAnnotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Annotations to add to the piper pod</td>
		</tr>
		<tr>
			<td>piper.resources</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Resource requests/limits for the piper container</td>
		</tr>
		<tr>
			<td>piper.service.port</td>
			<td>int</td>
			<td><pre lang="json">
10200
</pre>
</td>
			<td>piper service port</td>
		</tr>
		<tr>
			<td>piper.service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td>Kubernetes Service type used to expose piper</td>
		</tr>
		<tr>
			<td>piper.voice</td>
			<td>string</td>
			<td><pre lang="json">
"en_US-lessac-medium"
</pre>
</td>
			<td>Piper voice to load, e.g. en_US-lessac-medium. See https://github.com/rhasspy/piper/blob/master/VOICES.md</td>
		</tr>
		<tr>
			<td>podAnnotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Annotations to add to the Home Assistant pod</td>
		</tr>
		<tr>
			<td>podSecurityContext</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>resources</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>securityContext</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.port</td>
			<td>int</td>
			<td><pre lang="json">
8123
</pre>
</td>
			<td>Service port. Also used as the backend port by the ingress and httpRoute</td>
		</tr>
		<tr>
			<td>service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td>Kubernetes Service type used to expose Home Assistant</td>
		</tr>
		<tr>
			<td>serviceAccount.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Annotations to add to the service account</td>
		</tr>
		<tr>
			<td>serviceAccount.create</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Specifies whether a service account should be created</td>
		</tr>
		<tr>
			<td>serviceAccount.name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The name of the service account to use. If not set and create is true, a name is generated using the fullname template</td>
		</tr>
		<tr>
			<td>strategy</td>
			<td>string</td>
			<td><pre lang="json">
"RollingUpdate"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>tolerations</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Run a code-server (VS Code in the browser) sidecar, in the same pod, for editing the Home Assistant config directory</td>
		</tr>
		<tr>
			<td>vscode.extraEnv</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Additional environment variables for the code-server container</td>
		</tr>
		<tr>
			<td>vscode.hassConfig</td>
			<td>string</td>
			<td><pre lang="json">
"/config"
</pre>
</td>
			<td>Path to the Home Assistant config directory, mounted into the code-server container</td>
		</tr>
		<tr>
			<td>vscode.image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td>code-server image pull policy</td>
		</tr>
		<tr>
			<td>vscode.image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"codercom/code-server"
</pre>
</td>
			<td>code-server image repository</td>
		</tr>
		<tr>
			<td>vscode.image.tag</td>
			<td>string</td>
			<td><pre lang="json">
"4.131.0"
</pre>
</td>
			<td>code-server image tag</td>
		</tr>
		<tr>
			<td>vscode.password</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Password to require for code-server, stored in a Secret. Leave empty to disable auth (--auth=none) — only safe if the service isn't exposed outside the cluster</td>
		</tr>
		<tr>
			<td>vscode.resources</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Resource requests/limits for the code-server container</td>
		</tr>
		<tr>
			<td>vscode.service.nodePort</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>NodePort to request for the code-server port, when service.type (the shared Service's type) is NodePort</td>
		</tr>
		<tr>
			<td>vscode.service.port</td>
			<td>int</td>
			<td><pre lang="json">
8080
</pre>
</td>
			<td>code-server service port, exposed alongside the main Home Assistant port on the same Service. Also used as the container's listen port, so it must be >1024 since the image runs as a non-root user</td>
		</tr>
		<tr>
			<td>vscode.vscodePath</td>
			<td>string</td>
			<td><pre lang="json">
"/config/.vscode"
</pre>
</td>
			<td>Path to code-server's own settings/extensions directory, inside hassConfig</td>
		</tr>
		<tr>
			<td>whisper.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Deploy a wyoming-whisper speech-to-text service alongside Home Assistant. Add it in Home Assistant via Settings > Devices & Services > Add Integration > Wyoming Protocol, pointing at the whisper Service on its port</td>
		</tr>
		<tr>
			<td>whisper.extraArgs</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Additional command-line arguments passed to wyoming-whisper</td>
		</tr>
		<tr>
			<td>whisper.image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td>wyoming-whisper image pull policy</td>
		</tr>
		<tr>
			<td>whisper.image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"rhasspy/wyoming-whisper"
</pre>
</td>
			<td>wyoming-whisper image repository</td>
		</tr>
		<tr>
			<td>whisper.image.tag</td>
			<td>string</td>
			<td><pre lang="json">
"3.5.0"
</pre>
</td>
			<td>wyoming-whisper image tag</td>
		</tr>
		<tr>
			<td>whisper.model</td>
			<td>string</td>
			<td><pre lang="json">
"small"
</pre>
</td>
			<td>Whisper model to load. See https://github.com/rhasspy/wyoming-whisper#models</td>
		</tr>
		<tr>
			<td>whisper.persistence.accessMode</td>
			<td>string</td>
			<td><pre lang="json">
"ReadWriteOnce"
</pre>
</td>
			<td>Access mode for the whisper PVC</td>
		</tr>
		<tr>
			<td>whisper.persistence.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Persist the whisper model cache across restarts</td>
		</tr>
		<tr>
			<td>whisper.persistence.existingClaim</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Use an existing PVC instead of creating one. Leave empty to let the chart create it</td>
		</tr>
		<tr>
			<td>whisper.persistence.size</td>
			<td>string</td>
			<td><pre lang="json">
"2Gi"
</pre>
</td>
			<td>Size of the whisper PVC</td>
		</tr>
		<tr>
			<td>whisper.persistence.storageClass</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>StorageClass to request for the whisper PVC. Leave empty to use the cluster's default StorageClass</td>
		</tr>
		<tr>
			<td>whisper.podAnnotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Annotations to add to the whisper pod</td>
		</tr>
		<tr>
			<td>whisper.resources</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Resource requests/limits for the whisper container</td>
		</tr>
		<tr>
			<td>whisper.service.port</td>
			<td>int</td>
			<td><pre lang="json">
10300
</pre>
</td>
			<td>whisper service port</td>
		</tr>
		<tr>
			<td>whisper.service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td>Kubernetes Service type used to expose whisper</td>
		</tr>
	</tbody>
</table>

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
