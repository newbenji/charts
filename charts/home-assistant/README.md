
# Home Assistant

HomeAssistant is an open source home automation that puts local control and privacy first.
Powered by a worldwide community of tinkerers and DIY enthusiasts.
Perfect to run on a Raspberry Pi or a local server..

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2023.11.1](https://img.shields.io/badge/AppVersion-2023.11.1-informational?style=flat-square)

## Installing the Chart

This chart is published as an OCI artifact to the GitHub Container Registry.

To install it with the release name `my-release`:

```console
$ helm install my-release oci://ghcr.io/newbenji/charts/home-assistant --version 0.2.0
```

To just download the chart package:

```console
$ helm pull oci://ghcr.io/newbenji/charts/home-assistant --version 0.2.0
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config.automations | object | `{}` |  |
| config.blueprints | object | `{}` |  |
| config.http.ip_ban_enabled | bool | `false` |  |
| config.http.login_attempts_threshold | int | `5` |  |
| config.http.trusted_proxies | list | `[]` |  |
| config.http.use_x_forwarded_for | bool | `false` |  |
| config.recorder.purge_keep_days | int | `30` |  |
| config.scripts | object | `{}` |  |
| dnsPolicy | string | `"ClusterFirstWithHostNet"` | Dns policy |
| fullnameOverride | string | `""` |  |
| hadbconfig | string | `""` | Recorder database connection string, written into secrets.yaml as `hadbconfig` and referenced by config.recorder's db_url. Must be set to a real connection string. |
| homeAssistant.persistence.volumeName | string | `""` | Bind the PVC to a specific pre-provisioned PersistentVolume by name. Leave empty to let the cluster's default provisioner handle it. |
| hostNetwork | bool | `true` | Enables host networking (so that home assistant can scan devices automatically on the same network). If set to false, you might want to amend dnsPolicy value as well |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"homeassistant/home-assistant"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.additionalMounts | list | `[]` |  |
| persistence.additionalVolumes | list | `[]` |  |
| persistence.enabled | bool | `true` |  |
| persistence.existingClaim | string | `""` |  |
| persistence.size | string | `"5Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `8123` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| strategy | string | `"RollingUpdate"` |  |
| tolerations | list | `[]` |  |
| vscode.enabled | bool | `false` |  |
| vscode.extraEnv | object | `{}` |  |
| vscode.hassConfig | string | `"/config"` |  |
| vscode.image.pullPolicy | string | `"IfNotPresent"` |  |
| vscode.image.repository | string | `"codercom/code-server"` |  |
| vscode.image.tag | string | `"4.11.0"` |  |
| vscode.ingress.annotations | object | `{}` |  |
| vscode.ingress.enabled | bool | `false` |  |
| vscode.ingress.hosts[0] | string | `"home-assistant.local"` |  |
| vscode.ingress.path | string | `"/"` |  |
| vscode.ingress.tls | list | `[]` |  |
| vscode.service.annotations | object | `{}` |  |
| vscode.service.clusterIP | string | `""` |  |
| vscode.service.externalIPs | list | `[]` |  |
| vscode.service.labels | object | `{}` |  |
| vscode.service.loadBalancerIP | string | `""` |  |
| vscode.service.loadBalancerSourceRanges | list | `[]` |  |
| vscode.service.port | int | `80` |  |
| vscode.service.type | string | `"ClusterIP"` |  |
| vscode.vscodePath | string | `"/config/.vscode"` |  |

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
			<td></td>
		</tr>
		<tr>
			<td>config.blueprints</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>config.http.ip_ban_enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>config.http.login_attempts_threshold</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>config.http.trusted_proxies</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>config.http.use_x_forwarded_for</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>config.recorder.purge_keep_days</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>config.scripts</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
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
			<td>image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"homeassistant/home-assistant"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>image.tag</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
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
			<td></td>
		</tr>
		<tr>
			<td>ingress.className</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.hosts[0].host</td>
			<td>string</td>
			<td><pre lang="json">
"chart-example.local"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.hosts[0].paths[0].path</td>
			<td>string</td>
			<td><pre lang="json">
"/"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.hosts[0].paths[0].pathType</td>
			<td>string</td>
			<td><pre lang="json">
"ImplementationSpecific"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.tls</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
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
			<td></td>
		</tr>
		<tr>
			<td>persistence.additionalMounts</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.additionalVolumes</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.existingClaim</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.size</td>
			<td>string</td>
			<td><pre lang="json">
"5Gi"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.storageClass</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>podAnnotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
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
			<td></td>
		</tr>
		<tr>
			<td>service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>serviceAccount.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>serviceAccount.create</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>serviceAccount.name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
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
			<td></td>
		</tr>
		<tr>
			<td>vscode.extraEnv</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.hassConfig</td>
			<td>string</td>
			<td><pre lang="json">
"/config"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"codercom/code-server"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.image.tag</td>
			<td>string</td>
			<td><pre lang="json">
"4.11.0"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.ingress.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.ingress.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.ingress.hosts[0]</td>
			<td>string</td>
			<td><pre lang="json">
"home-assistant.local"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.ingress.path</td>
			<td>string</td>
			<td><pre lang="json">
"/"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.ingress.tls</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.service.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.service.clusterIP</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.service.externalIPs</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.service.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.service.loadBalancerIP</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.service.loadBalancerSourceRanges</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.service.port</td>
			<td>int</td>
			<td><pre lang="json">
80
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>vscode.vscodePath</td>
			<td>string</td>
			<td><pre lang="json">
"/config/.vscode"
</pre>
</td>
			<td></td>
		</tr>
	</tbody>
</table>

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
