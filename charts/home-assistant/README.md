
# Home Assistant

HomeAssistant is an open source home automation that puts local control and privacy first.
Powered by a worldwide community of tinkerers and DIY enthusiasts.
Perfect to run on a Raspberry Pi or a local server..

![Version: 0.7.1](https://img.shields.io/badge/Version-0.7.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2026.8.0](https://img.shields.io/badge/AppVersion-2026.8.0-informational?style=flat-square)

## Installing the Chart

This chart is published two ways: as a classic Helm repo via GitHub Pages
(releases only), and as an OCI artifact via the GitHub Container Registry
(releases and alpha builds).

Via the classic repo:

```console
$ helm repo add newbenji-charts https://newbenji.github.io/charts/
$ helm repo update
$ helm install my-release newbenji-charts/home-assistant --version 0.7.1
```

Via OCI:

```console
$ helm install my-release oci://ghcr.io/newbenji/charts/home-assistant --version 0.7.1
```

To just download the chart package:

```console
$ helm pull oci://ghcr.io/newbenji/charts/home-assistant --version 0.7.1
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config.automations | list | `[]` | DEPRECATED, to be removed: use an `automation:` section in config.packages instead. List of automations, mounted read-only at /config/automations/automations.yaml - deliberately not /config/automations.yaml, which HA's UI automation editor writes to. Load them alongside the UI ones by adding `automation chart: !include automations/automations.yaml` to configuration.yaml. See https://www.home-assistant.io/docs/automation/yaml/ |
| config.blueprints.automation | object | `{}` | Automation blueprints as a map of file name to blueprint, mounted read-only into /config/blueprints/automation/helm/. Each blueprint is either a YAML string, or a map in which HA tags must be quoted (`"!input motion_entity"`) since Helm drops unquoted custom tags. See https://www.home-assistant.io/docs/automation/using_blueprints/ |
| config.blueprints.script | object | `{}` | Script blueprints, same format as blueprints.automation, mounted into /config/blueprints/script/helm/ |
| config.configuration.content | string | `"# Loads default set of integrations. Do not remove.\ndefault_config:\n\n# Load frontend themes from the themes folder\nfrontend:\n  themes: !include_dir_merge_named themes\n\nautomation: !include automations.yaml\nscript: !include scripts.yaml\nscene: !include scenes.yaml\n"` | configuration.yaml body (seed/managed mode), as a YAML string (rendered as-is, comments kept) or a map with quoted HA tags. Must not define `homeassistant:` - use config.configuration.homeassistant. The default is Home Assistant's own default configuration. Keep the automation/script/scene includes so HA's UI editors keep working - they write to those files on the PVC |
| config.configuration.homeassistant | object | `{}` | Settings for the `homeassistant:` block of configuration.yaml (seed/managed mode), e.g. name, time_zone, customize. The chart adds `packages: !include_dir_named packages` here when config.packages is set. HA tags must be quoted, e.g. `customize: "!include customize.yaml"` |
| config.configuration.mode | string | `"unmanaged"` | Who owns /config/configuration.yaml. `unmanaged`: the chart doesn't touch it (HA writes its default on first boot; add includes by hand). `seed`: an initContainer writes the rendered file only if none exists yet, after which it's yours to edit. `managed`: the rendered file is mounted read-only and every change rolls the pod - configuration.yaml lives in Git. In seed and managed mode, empty automations.yaml/scripts.yaml/scenes.yaml are created if missing, since HA only creates those alongside its own default configuration.yaml. Switching an existing install to managed hides the configuration.yaml on the PVC - paste it into content first |
| config.http.ip_ban_enabled | bool | `false` | Ban IPs after too many failed login attempts |
| config.http.login_attempts_threshold | int | `5` | Number of failed login attempts before an IP is banned |
| config.http.trusted_proxies | list | `[]` | CIDR ranges of reverse proxies trusted to set X-Forwarded-For/X-Forwarded-Proto |
| config.http.use_x_forwarded_for | bool | `false` | Trust the X-Forwarded-For header from trusted_proxies. See https://www.home-assistant.io/integrations/http/. DEPRECATED along with all of config.http, to be removed: use an `http:` section in config.packages instead |
| config.notify | list | `[]` | DEPRECATED, to be removed: use a `notify:` section in config.packages instead. Rendered into configmap-notify.yaml as Home Assistant's notify platform config |
| config.packages | object | `{}` | Home Assistant packages (https://www.home-assistant.io/docs/configuration/packages/) as a map of file name (must end in .yaml) to package, mounted read-only into /config/packages/. A package can hold any mix of integrations - automation, script, template, sensor, recorder, ... Each is either a YAML string (rendered as-is, comments kept), or a map in which HA tags must be quoted (`db_url: "!secret hadbconfig"`), since Helm silently drops unquoted custom tags from values. Load them all by adding this once to configuration.yaml: `homeassistant: {packages: !include_dir_named packages}`. Mounting this hides any packages/ directory already on the PVC. A change rolls the pod |
| config.recorder.purge_keep_days | int | `30` | Number of days of history to keep in the recorder database. See https://www.home-assistant.io/integrations/recorder/. DEPRECATED along with all of config.recorder, to be removed: use a `recorder:` section in config.packages instead |
| config.scripts | object | `{}` | DEPRECATED, to be removed: use a `script:` section in config.packages instead. Scripts, mounted read-only at /config/scripts/scripts.yaml. Load them by adding e.g. `script chart: !include scripts/scripts.yaml` to configuration.yaml. See https://www.home-assistant.io/docs/scripts/ |
| config.secrets.existingSecret | string | `""` | Mount /config/secrets.yaml (what `!secret` reads) from this existing Secret, e.g. one created by ExternalSecrets, SOPS or SealedSecrets. Each key in the Secret becomes one `key: value` entry, written by an initContainer at pod start (a single trailing newline is stripped from each value). Replaces any secrets.yaml already on the PVC - move its entries into the Secret first. Changes only apply on the next pod start; use e.g. Reloader via podAnnotations to restart automatically |
| config.secrets.fileKey | string | `""` | Instead of building secrets.yaml from all keys, mount this one key of the Secret as the complete secrets.yaml file |
| config.secrets.values | object | `{}` | Secrets to put in a chart-created Secret instead of existingSecret, as key: value. Convenient but lands in your values in plain text - prefer existingSecret for anything committed to Git |
| config.telegram_bot | list | `[]` | Rendered into configmap-telegram-bot.yaml as Home Assistant's telegram_bot platform config. DEPRECATED: current Home Assistant no longer supports YAML setup for telegram_bot and errors on load - set it up via Settings > Devices & Services instead |
| dnsPolicy | string | `"ClusterFirstWithHostNet"` | Dns policy |
| extraContainerPorts | list | `[]` | Additional ports to open on the Home Assistant container, e.g. for integrations that listen on their own port (ESPHome dashboard, Matter, HomeKit Bridge, etc). Set `count` greater than 1 to open a contiguous range starting at containerPort. Port names must stay within Kubernetes' 15-character limit and be unique |
| extraManifests | list | `[]` | Additional arbitrary Kubernetes manifests to render alongside the chart, e.g. an ExternalSecret or a NetworkPolicy. Each entry is either a map (rendered via toYaml) or a string (rendered as-is); both are passed through tpl, so release/values templating works inside them |
| fullnameOverride | string | `""` |  |
| hadbconfig | string | `""` | Recorder database connection string, written into secrets.yaml as `hadbconfig` and referenced by config.recorder's db_url. DEPRECATED, to be removed: put it in config.secrets and reference it from a `recorder:` package as `db_url: "!secret hadbconfig"`. |
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
| matterServer.enabled | bool | `false` | IMPORTANT: the image runs as a non-root user (uid 1000). If the Home Assistant container runs as root (the chart's default - see securityContext above), that user can't write to the shared config volume unless you set podSecurityContext.fsGroup: 1000 (or matching whatever uid the image uses) - otherwise this crash-loops on "EACCES: permission denied, mkdir '/data/config'" and, since Kubernetes requires every container in the pod Ready before the pod joins its Service, takes Home Assistant itself offline too even though it isn't the one failing |
| matterServer.extraArgs | list | `[]` | Additional command-line arguments, e.g. ["--primary-interface", "eth0"] if host network binds to the wrong interface for mDNS |
| matterServer.extraEnv | object | `{}` | Additional environment variables for the matter-server container |
| matterServer.image.pullPolicy | string | `"IfNotPresent"` | matterjs-server image pull policy |
| matterServer.image.repository | string | `"ghcr.io/matter-js/matterjs-server"` | matterjs-server image repository |
| matterServer.image.tag | string | `"stable"` | matterjs-server image tag |
| matterServer.port | int | `5580` | WebSocket API port |
| matterServer.resources | object | `{}` | Resource requests/limits for the matter-server container |
| matterServer.securityContext | object | `{}` | Security context for the matter-server container. Add capabilities: [NET_RAW] here if you need its device-ping functionality |
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
| zigbee2mqtt.advanced.transmitPower | string | `""` | Radio transmit power in dBm, if supported by the adapter. Leave empty for the adapter default |
| zigbee2mqtt.enabled | bool | `false` | Deploy Zigbee2MQTT alongside Home Assistant, bridging a Zigbee network to the MQTT broker configured below. Devices show up in Home Assistant automatically via MQTT discovery, no separate HA-side config needed |
| zigbee2mqtt.extraEnv | object | `{}` | Additional environment variables for the zigbee2mqtt container, e.g. further ZIGBEE2MQTT_CONFIG_* overrides. See https://www.zigbee2mqtt.io/guide/configuration/ for the env var naming convention |
| zigbee2mqtt.httpRoute.annotations | object | `{}` | Annotations to add to the HTTPRoute |
| zigbee2mqtt.httpRoute.enabled | bool | `false` | Expose the zigbee2mqtt web UI via a Gateway API HTTPRoute instead of an Ingress. Requires the Gateway API CRDs and a Gateway to already exist in the cluster. Mutually exclusive with zigbee2mqtt.ingress.enabled |
| zigbee2mqtt.httpRoute.hostnames | list | `[]` | Hostnames the route matches. Leave empty to match all hostnames on the parent Gateway listener(s) |
| zigbee2mqtt.httpRoute.labels | object | `{}` | Additional labels to add to the HTTPRoute |
| zigbee2mqtt.httpRoute.matches | list | `[{"path":"/","pathType":"PathPrefix"}]` | Path matches routed to the zigbee2mqtt service |
| zigbee2mqtt.httpRoute.parentRefs | list | `[{"name":""}]` | References to the Gateway(s) this route attaches to |
| zigbee2mqtt.image.pullPolicy | string | `"IfNotPresent"` | zigbee2mqtt image pull policy |
| zigbee2mqtt.image.repository | string | `"docker.io/koenkk/zigbee2mqtt"` | zigbee2mqtt image repository |
| zigbee2mqtt.image.tag | string | `"2.13.0"` | zigbee2mqtt image tag |
| zigbee2mqtt.ingress.annotations | object | `{}` | Annotations to add to the Ingress |
| zigbee2mqtt.ingress.className | string | `""` | IngressClass to use, e.g. "nginx". Leave empty to use the cluster's default IngressClass |
| zigbee2mqtt.ingress.enabled | bool | `false` | Expose the zigbee2mqtt web UI via a classic Ingress resource. Mutually exclusive with zigbee2mqtt.httpRoute.enabled |
| zigbee2mqtt.ingress.hosts | list | `[]` | Host/path rules routed to the zigbee2mqtt service |
| zigbee2mqtt.ingress.tls | list | `[]` | TLS configuration for the Ingress |
| zigbee2mqtt.mqtt.baseTopic | string | `"zigbee2mqtt"` | MQTT base topic |
| zigbee2mqtt.mqtt.password | string | `""` | MQTT password, leave empty if the broker allows anonymous access |
| zigbee2mqtt.mqtt.server | string | `""` | MQTT broker URL, e.g. mqtt://mosquitto.mosquitto.svc.cluster.local:1883 |
| zigbee2mqtt.mqtt.user | string | `""` | MQTT username, leave empty if the broker allows anonymous access |
| zigbee2mqtt.permitJoin | bool | `false` | Allow new devices to join the Zigbee network. Prefer toggling this from the zigbee2mqtt web UI while pairing instead of leaving it enabled permanently |
| zigbee2mqtt.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the zigbee2mqtt PVC |
| zigbee2mqtt.persistence.enabled | bool | `true` | Persist the zigbee2mqtt database (network key, paired devices, logs) across restarts. Strongly recommended - losing this means re-pairing every Zigbee device |
| zigbee2mqtt.persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one. Leave empty to let the chart create it |
| zigbee2mqtt.persistence.size | string | `"1Gi"` | Size of the zigbee2mqtt PVC |
| zigbee2mqtt.persistence.storageClass | string | `""` | StorageClass to request for the zigbee2mqtt PVC. Leave empty to use the cluster's default StorageClass |
| zigbee2mqtt.podAnnotations | object | `{}` | Annotations to add to the zigbee2mqtt pod |
| zigbee2mqtt.resources | object | `{}` | Resource requests/limits for the zigbee2mqtt container |
| zigbee2mqtt.serial.adapter | string | `"auto"` | Zigbee adapter type: auto, zstack, ember, deconz, zigate, or zboss. See https://www.zigbee2mqtt.io/guide/adapters/ |
| zigbee2mqtt.serial.baudrate | string | `""` | Serial baudrate. Leave empty to use the adapter's default |
| zigbee2mqtt.serial.disableLed | bool | `false` | Disable the adapter's status LED, if supported |
| zigbee2mqtt.serial.port | string | `""` | Zigbee adapter connection string. For a USB dongle this is a /dev/tty* path (see zigbee2mqtt.persistence.device below); for a network-attached coordinator (e.g. SMLIGHT SLZB-* devices) this is a tcp://host:port URL |
| zigbee2mqtt.service.port | int | `8080` | zigbee2mqtt frontend (web UI + API) port |
| zigbee2mqtt.service.type | string | `"ClusterIP"` | Kubernetes Service type used to expose the zigbee2mqtt frontend |
| zigbee2mqtt.timezone | string | `"UTC"` | Timezone passed to the container, used for log timestamps |

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
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>DEPRECATED, to be removed: use an `automation:` section in config.packages instead. List of automations, mounted read-only at /config/automations/automations.yaml - deliberately not /config/automations.yaml, which HA's UI automation editor writes to. Load them alongside the UI ones by adding `automation chart: !include automations/automations.yaml` to configuration.yaml. See https://www.home-assistant.io/docs/automation/yaml/</td>
		</tr>
		<tr>
			<td>config.blueprints.automation</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Automation blueprints as a map of file name to blueprint, mounted read-only into /config/blueprints/automation/helm/. Each blueprint is either a YAML string, or a map in which HA tags must be quoted (`"!input motion_entity"`) since Helm drops unquoted custom tags. See https://www.home-assistant.io/docs/automation/using_blueprints/</td>
		</tr>
		<tr>
			<td>config.blueprints.script</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Script blueprints, same format as blueprints.automation, mounted into /config/blueprints/script/helm/</td>
		</tr>
		<tr>
			<td>config.configuration.content</td>
			<td>string</td>
			<td><pre lang="json">
"# Loads default set of integrations. Do not remove.\ndefault_config:\n\n# Load frontend themes from the themes folder\nfrontend:\n  themes: !include_dir_merge_named themes\n\nautomation: !include automations.yaml\nscript: !include scripts.yaml\nscene: !include scenes.yaml\n"
</pre>
</td>
			<td>configuration.yaml body (seed/managed mode), as a YAML string (rendered as-is, comments kept) or a map with quoted HA tags. Must not define `homeassistant:` - use config.configuration.homeassistant. The default is Home Assistant's own default configuration. Keep the automation/script/scene includes so HA's UI editors keep working - they write to those files on the PVC</td>
		</tr>
		<tr>
			<td>config.configuration.homeassistant</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Settings for the `homeassistant:` block of configuration.yaml (seed/managed mode), e.g. name, time_zone, customize. The chart adds `packages: !include_dir_named packages` here when config.packages is set. HA tags must be quoted, e.g. `customize: "!include customize.yaml"`</td>
		</tr>
		<tr>
			<td>config.configuration.mode</td>
			<td>string</td>
			<td><pre lang="json">
"unmanaged"
</pre>
</td>
			<td>Who owns /config/configuration.yaml. `unmanaged`: the chart doesn't touch it (HA writes its default on first boot; add includes by hand). `seed`: an initContainer writes the rendered file only if none exists yet, after which it's yours to edit. `managed`: the rendered file is mounted read-only and every change rolls the pod - configuration.yaml lives in Git. In seed and managed mode, empty automations.yaml/scripts.yaml/scenes.yaml are created if missing, since HA only creates those alongside its own default configuration.yaml. Switching an existing install to managed hides the configuration.yaml on the PVC - paste it into content first</td>
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
			<td>Trust the X-Forwarded-For header from trusted_proxies. See https://www.home-assistant.io/integrations/http/. DEPRECATED along with all of config.http, to be removed: use an `http:` section in config.packages instead</td>
		</tr>
		<tr>
			<td>config.notify</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>DEPRECATED, to be removed: use a `notify:` section in config.packages instead. Rendered into configmap-notify.yaml as Home Assistant's notify platform config</td>
		</tr>
		<tr>
			<td>config.packages</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Home Assistant packages (https://www.home-assistant.io/docs/configuration/packages/) as a map of file name (must end in .yaml) to package, mounted read-only into /config/packages/. A package can hold any mix of integrations - automation, script, template, sensor, recorder, ... Each is either a YAML string (rendered as-is, comments kept), or a map in which HA tags must be quoted (`db_url: "!secret hadbconfig"`), since Helm silently drops unquoted custom tags from values. Load them all by adding this once to configuration.yaml: `homeassistant: {packages: !include_dir_named packages}`. Mounting this hides any packages/ directory already on the PVC. A change rolls the pod</td>
		</tr>
		<tr>
			<td>config.recorder.purge_keep_days</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td>Number of days of history to keep in the recorder database. See https://www.home-assistant.io/integrations/recorder/. DEPRECATED along with all of config.recorder, to be removed: use a `recorder:` section in config.packages instead</td>
		</tr>
		<tr>
			<td>config.scripts</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>DEPRECATED, to be removed: use a `script:` section in config.packages instead. Scripts, mounted read-only at /config/scripts/scripts.yaml. Load them by adding e.g. `script chart: !include scripts/scripts.yaml` to configuration.yaml. See https://www.home-assistant.io/docs/scripts/</td>
		</tr>
		<tr>
			<td>config.secrets.existingSecret</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Mount /config/secrets.yaml (what `!secret` reads) from this existing Secret, e.g. one created by ExternalSecrets, SOPS or SealedSecrets. Each key in the Secret becomes one `key: value` entry, written by an initContainer at pod start (a single trailing newline is stripped from each value). Replaces any secrets.yaml already on the PVC - move its entries into the Secret first. Changes only apply on the next pod start; use e.g. Reloader via podAnnotations to restart automatically</td>
		</tr>
		<tr>
			<td>config.secrets.fileKey</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Instead of building secrets.yaml from all keys, mount this one key of the Secret as the complete secrets.yaml file</td>
		</tr>
		<tr>
			<td>config.secrets.values</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Secrets to put in a chart-created Secret instead of existingSecret, as key: value. Convenient but lands in your values in plain text - prefer existingSecret for anything committed to Git</td>
		</tr>
		<tr>
			<td>config.telegram_bot</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Rendered into configmap-telegram-bot.yaml as Home Assistant's telegram_bot platform config. DEPRECATED: current Home Assistant no longer supports YAML setup for telegram_bot and errors on load - set it up via Settings > Devices & Services instead</td>
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
			<td>Recorder database connection string, written into secrets.yaml as `hadbconfig` and referenced by config.recorder's db_url. DEPRECATED, to be removed: put it in config.secrets and reference it from a `recorder:` package as `db_url: "!secret hadbconfig"`.</td>
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
			<td>matterServer.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>IMPORTANT: the image runs as a non-root user (uid 1000). If the Home Assistant container runs as root (the chart's default - see securityContext above), that user can't write to the shared config volume unless you set podSecurityContext.fsGroup: 1000 (or matching whatever uid the image uses) - otherwise this crash-loops on "EACCES: permission denied, mkdir '/data/config'" and, since Kubernetes requires every container in the pod Ready before the pod joins its Service, takes Home Assistant itself offline too even though it isn't the one failing</td>
		</tr>
		<tr>
			<td>matterServer.extraArgs</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Additional command-line arguments, e.g. ["--primary-interface", "eth0"] if host network binds to the wrong interface for mDNS</td>
		</tr>
		<tr>
			<td>matterServer.extraEnv</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Additional environment variables for the matter-server container</td>
		</tr>
		<tr>
			<td>matterServer.image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td>matterjs-server image pull policy</td>
		</tr>
		<tr>
			<td>matterServer.image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"ghcr.io/matter-js/matterjs-server"
</pre>
</td>
			<td>matterjs-server image repository</td>
		</tr>
		<tr>
			<td>matterServer.image.tag</td>
			<td>string</td>
			<td><pre lang="json">
"stable"
</pre>
</td>
			<td>matterjs-server image tag</td>
		</tr>
		<tr>
			<td>matterServer.port</td>
			<td>int</td>
			<td><pre lang="json">
5580
</pre>
</td>
			<td>WebSocket API port</td>
		</tr>
		<tr>
			<td>matterServer.resources</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Resource requests/limits for the matter-server container</td>
		</tr>
		<tr>
			<td>matterServer.securityContext</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Security context for the matter-server container. Add capabilities: [NET_RAW] here if you need its device-ping functionality</td>
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
		<tr>
			<td>zigbee2mqtt.advanced.transmitPower</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Radio transmit power in dBm, if supported by the adapter. Leave empty for the adapter default</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Deploy Zigbee2MQTT alongside Home Assistant, bridging a Zigbee network to the MQTT broker configured below. Devices show up in Home Assistant automatically via MQTT discovery, no separate HA-side config needed</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.extraEnv</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Additional environment variables for the zigbee2mqtt container, e.g. further ZIGBEE2MQTT_CONFIG_* overrides. See https://www.zigbee2mqtt.io/guide/configuration/ for the env var naming convention</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.httpRoute.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Annotations to add to the HTTPRoute</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.httpRoute.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Expose the zigbee2mqtt web UI via a Gateway API HTTPRoute instead of an Ingress. Requires the Gateway API CRDs and a Gateway to already exist in the cluster. Mutually exclusive with zigbee2mqtt.ingress.enabled</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.httpRoute.hostnames</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Hostnames the route matches. Leave empty to match all hostnames on the parent Gateway listener(s)</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.httpRoute.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Additional labels to add to the HTTPRoute</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.httpRoute.matches</td>
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
			<td>Path matches routed to the zigbee2mqtt service</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.httpRoute.parentRefs</td>
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
			<td>zigbee2mqtt.image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td>zigbee2mqtt image pull policy</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"docker.io/koenkk/zigbee2mqtt"
</pre>
</td>
			<td>zigbee2mqtt image repository</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.image.tag</td>
			<td>string</td>
			<td><pre lang="json">
"2.13.0"
</pre>
</td>
			<td>zigbee2mqtt image tag</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.ingress.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Annotations to add to the Ingress</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.ingress.className</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>IngressClass to use, e.g. "nginx". Leave empty to use the cluster's default IngressClass</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.ingress.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Expose the zigbee2mqtt web UI via a classic Ingress resource. Mutually exclusive with zigbee2mqtt.httpRoute.enabled</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.ingress.hosts</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Host/path rules routed to the zigbee2mqtt service</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.ingress.tls</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>TLS configuration for the Ingress</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.mqtt.baseTopic</td>
			<td>string</td>
			<td><pre lang="json">
"zigbee2mqtt"
</pre>
</td>
			<td>MQTT base topic</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.mqtt.password</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>MQTT password, leave empty if the broker allows anonymous access</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.mqtt.server</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>MQTT broker URL, e.g. mqtt://mosquitto.mosquitto.svc.cluster.local:1883</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.mqtt.user</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>MQTT username, leave empty if the broker allows anonymous access</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.permitJoin</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Allow new devices to join the Zigbee network. Prefer toggling this from the zigbee2mqtt web UI while pairing instead of leaving it enabled permanently</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.persistence.accessMode</td>
			<td>string</td>
			<td><pre lang="json">
"ReadWriteOnce"
</pre>
</td>
			<td>Access mode for the zigbee2mqtt PVC</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.persistence.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Persist the zigbee2mqtt database (network key, paired devices, logs) across restarts. Strongly recommended - losing this means re-pairing every Zigbee device</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.persistence.existingClaim</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Use an existing PVC instead of creating one. Leave empty to let the chart create it</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.persistence.size</td>
			<td>string</td>
			<td><pre lang="json">
"1Gi"
</pre>
</td>
			<td>Size of the zigbee2mqtt PVC</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.persistence.storageClass</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>StorageClass to request for the zigbee2mqtt PVC. Leave empty to use the cluster's default StorageClass</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.podAnnotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Annotations to add to the zigbee2mqtt pod</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.resources</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Resource requests/limits for the zigbee2mqtt container</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.serial.adapter</td>
			<td>string</td>
			<td><pre lang="json">
"auto"
</pre>
</td>
			<td>Zigbee adapter type: auto, zstack, ember, deconz, zigate, or zboss. See https://www.zigbee2mqtt.io/guide/adapters/</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.serial.baudrate</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Serial baudrate. Leave empty to use the adapter's default</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.serial.disableLed</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disable the adapter's status LED, if supported</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.serial.port</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Zigbee adapter connection string. For a USB dongle this is a /dev/tty* path (see zigbee2mqtt.persistence.device below); for a network-attached coordinator (e.g. SMLIGHT SLZB-* devices) this is a tcp://host:port URL</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.service.port</td>
			<td>int</td>
			<td><pre lang="json">
8080
</pre>
</td>
			<td>zigbee2mqtt frontend (web UI + API) port</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td>Kubernetes Service type used to expose the zigbee2mqtt frontend</td>
		</tr>
		<tr>
			<td>zigbee2mqtt.timezone</td>
			<td>string</td>
			<td><pre lang="json">
"UTC"
</pre>
</td>
			<td>Timezone passed to the container, used for log timestamps</td>
		</tr>
	</tbody>
</table>

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
