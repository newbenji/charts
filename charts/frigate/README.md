
# frigate

NVR With Realtime Object Detection for IP Cameras

![Version: 7.10.0](https://img.shields.io/badge/Version-7.10.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.17.2](https://img.shields.io/badge/AppVersion-0.17.2-informational?style=flat-square)

This chart installs [Frigate](https://frigate.video/) on Kubernetes.

## Fork

This chart started as a fork of [`blakeblackshear/blakeshome-charts`](https://github.com/blakeblackshear/blakeshome-charts)'
`frigate` chart, which appears to be unmaintained (open issues and pull
requests going back years with no response). It's maintained and improved
here going forward — see the changelog below for what's changed since the
fork.

## Installing the Chart

This chart is published two ways: as a classic Helm repo via GitHub Pages
(releases only), and as an OCI artifact via the GitHub Container Registry
(releases and alpha builds).

Via the classic repo:

```console
$ helm repo add newbenji-charts https://newbenji.github.io/charts/
$ helm repo update
$ helm install my-release newbenji-charts/frigate --version 7.10.0
```

Via OCI:

```console
$ helm install my-release oci://ghcr.io/newbenji/charts/frigate --version 7.10.0
```

To just download the chart package:

```console
$ helm pull oci://ghcr.io/newbenji/charts/frigate --version 7.10.0
```

#### Minimum Config

At minimum, you'll need to define the following Frigate configuration properties. For more information, see the [Docs](https://docs.frigate.video/configuration/index).

```yaml
# values.yaml
config:
  mqtt:
    host: "mqtt.example.com"
    port: 1883
    user: admin
    password: "<your_mqtt_password>"
  cameras:
    # Define at least one camera
    back:
      ffmpeg:
        inputs:
          - path: rtsp://viewer:{FRIGATE_RTSP_PASSWORD}@10.0.10.10:554/cam/realmonitor?channel=1&subtype=2
            roles:
              - detect
              - rtmp
      detect:
        width: 1280
        height: 720
```

`config` accepts either a native YAML map (as above) or a `|`-block string, if you prefer to paste Frigate's config verbatim.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| blakeblackshear | <blakeb@blakeshome.com> |  |
| billimek | <jeff@billimek.com> |  |
| newbenji | <benji@newbenji.dk> |  |

## Source Code

* <https://github.com/blakeblackshear/frigate>
* <https://github.com/blakeblackshear/blakeshome-charts>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Set Pod affinity rules |
| config | string | `"mqtt:\n  # Required: host name\n  host: mqtt.server.com\n  # Optional: port (default: shown below)\n  port: 1883\n  # Optional: topic prefix (default: shown below)\n  # WARNING: must be unique if you are running multiple instances\n  topic_prefix: frigate\n  # Optional: client id (default: shown below)\n  # WARNING: must be unique if you are running multiple instances\n  client_id: frigate\n  # Optional: user\n  user: mqtt_user\n  # Optional: password\n  # NOTE: Environment variables that begin with 'FRIGATE_' may be referenced in {}.\n  #       eg. password: '{FRIGATE_MQTT_PASSWORD}'\n  password: password\n  # Optional: interval in seconds for publishing stats (default: shown below)\n  stats_interval: 60\n\ndetectors:\n  # coral:\n  #   type: edgetpu\n  #   device: usb\n  cpu1:\n    type: cpu\n\n# cameras:\n#   # Name of your camera\n#   front_door:\n#     ffmpeg:\n#       inputs:\n#         - path: rtsp://{FRIGATE_RTSP_USERNAME}:{FRIGATE_RTSP_PASSWORD}@10.0.10.10:554/cam/realmonitor?channel=1&subtype=2\n#           roles:\n#             - detect\n#             - rtmp\n#     width: 1280\n#     height: 720\n#     fps: 5\n"` | frigate configuration - see [Docs](https://docs.frigate.video/configuration/index) for more info. Can be given as a `|`-block string (as below) or as a native YAML map - both are supported |
| coral.enabled | bool | `false` | enables the use of a Coral device |
| coral.hostPath | string | `"/dev/bus/usb"` | path on the host to which to mount the Coral device |
| dnsConfig | object | `{}` | Optional pod-level dnsConfig (e.g. to tune ndots). See https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config |
| env | object | `{}` | additional ENV variables to set. Prefix with FRIGATE_ to target Frigate configuration values |
| envFromSecrets | list | `[]` | set environment variables from Secret(s) |
| extraInitContainers | list | `[]` | Define extra init containers |
| extraVolumeMounts | list | `[]` | declare additional volume mounts |
| extraVolumes | list | `[]` | declare extra volumes to use for Frigate |
| fullnameOverride | string | `""` | Overrides the Full Name of resources |
| gpu.nvidia.enabled | bool | `false` | Enables NVIDIA GPU compatibility. Requires a Frigate image built with NVIDIA/TensorRT support and the NVIDIA device plugin/runtime installed on the node - see https://github.com/blakeblackshear/frigate/pkgs/container/frigate for available tags |
| gpu.nvidia.runtimeClassName | string | `nil` | Overrides the default runtimeClassName |
| httpRoute.annotations | object | `{}` | Annotations to add to the HTTPRoute |
| httpRoute.enabled | bool | `false` | Expose Frigate via a Gateway API HTTPRoute instead of an Ingress. Requires the Gateway API CRDs and a Gateway to already exist in the cluster. Mutually exclusive with ingress.enabled |
| httpRoute.hostnames | list | `[]` | Hostnames the route matches. Leave empty to match all hostnames on the parent Gateway listener(s) |
| httpRoute.labels | object | `{}` | Additional labels to add to the HTTPRoute |
| httpRoute.matches | list | `[{"path":"/","pathType":"PathPrefix","portName":"http-auth"}]` | Path matches routed to the Frigate service. `portName` is one of the Service's named ports (http, http-auth, rtmp, rtsp, webrtc-tcp, webrtc-udp, go2rtc-admin) |
| httpRoute.parentRefs | list | `[{"name":""}]` | References to the Gateway(s) this route attaches to |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.repository | string | `"ghcr.io/blakeblackshear/frigate"` | Docker registry/repository to pull the image from |
| image.tag | string | `nil` | Overrides the default tag (appVersion) used in Chart.yaml. See available tags at https://github.com/blakeblackshear/frigate/pkgs/container/frigate |
| imagePullSecrets | list | `[]` | Docker image pull policy |
| ingress.annotations | object | `{}` | annotations to configure your Ingress. See your Ingress Controller's Docs for more info. |
| ingress.enabled | bool | `false` | Enables the use of an Ingress Controller to front the Service and can provide HTTPS. Mutually exclusive with httpRoute.enabled |
| ingress.hosts | list | `[{"host":"chart.example.local","paths":[{"path":"/","portName":"http-auth"}]}]` | alternatively use `http` if anonymous auth is allowed |
| ingress.ingressClassName | string | `nil` | ingressClassName for using on clusters with multiple ingresses, default is null |
| ingress.tls | list | `[]` | list of TLS configurations |
| nameOverride | string | `""` | Overrides the name of resources |
| nodeSelector | object | `{}` | Node Selector configuration |
| persistence.config.accessMode | string | `"ReadWriteOnce"` | [access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use for the PVC |
| persistence.config.enabled | bool | `false` | Enables persistence for the config directory |
| persistence.config.ephemeralWritableConfigYaml | bool | `true` |  |
| persistence.config.seedOnly | bool | `false` | When true (and ephemeralWritableConfigYaml/persistence.config.enabled are both true), only seed config.yml from the ConfigMap if it doesn't already exist on the PVC, instead of overwriting it on every pod start. This lets Frigate's UI make changes that actually persist across restarts. The pod won't be restarted on values.config changes either, since they wouldn't take effect once seeded |
| persistence.config.size | string | `"100Mi"` | size/capacity of the PVC |
| persistence.config.skipuninstall | bool | `false` | Do not delete the pvc upon helm uninstall |
| persistence.data.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.data.enabled | bool | `false` |  |
| persistence.data.size | string | `"10Gi"` |  |
| persistence.data.skipuninstall | bool | `false` |  |
| persistence.media.accessMode | string | `"ReadWriteOnce"` | [access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use for the PVC |
| persistence.media.enabled | bool | `false` | Enables persistence for the media directory |
| persistence.media.size | string | `"10Gi"` | size/capacity of the PVC |
| persistence.media.skipuninstall | bool | `false` | Do not delete the pvc upon helm uninstall |
| podAnnotations | object | `{}` | Set additional pod Annotations |
| podSecurityContext | object | `{}` | will override it for frigate container |
| priorityClassName | string | `""` | Name of a PriorityClass to assign to the Pod. Leave empty for no priority (default scheduling) |
| probes.liveness.enabled | bool | `true` |  |
| probes.liveness.failureThreshold | int | `5` |  |
| probes.liveness.initialDelaySeconds | int | `30` |  |
| probes.liveness.timeoutSeconds | int | `10` |  |
| probes.readiness.enabled | bool | `true` |  |
| probes.readiness.failureThreshold | int | `5` |  |
| probes.readiness.initialDelaySeconds | int | `30` |  |
| probes.readiness.timeoutSeconds | int | `10` |  |
| probes.startup.enabled | bool | `false` |  |
| probes.startup.failureThreshold | int | `30` |  |
| probes.startup.periodSeconds | int | `10` |  |
| resources | object | `{}` | Set resource limits/requests for the Pod(s) |
| securityContext | object | `{}` | Set Frigate Container Security Context |
| service.annotations | object | `{}` |  |
| service.ipFamilies | list | `[]` |  |
| service.ipFamilyPolicy | string | `"SingleStack"` |  |
| service.labels | object | `{}` |  |
| service.loadBalancerIP | string | `nil` | Set specific IP address for LoadBalancer. `service.type` must be set to `LoadBalancer` |
| service.port | int | `5000` | Port the Service should communicate on |
| service.type | string | `"ClusterIP"` | Type of Service to use |
| shmSize | string | `"1Gi"` | amount of shared memory to use for caching |
| strategyType | string | `"Recreate"` | upgrade strategy type (e.g. Recreate or RollingUpdate) |
| tmpfs | object | `{"enabled":true,"sizeLimit":"1Gi"}` | use memory for tmpfs (mounted to /tmp) |
| tolerations | list | `[]` | Node toleration configuration |

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
			<td>Set Pod affinity rules</td>
		</tr>
		<tr>
			<td>config</td>
			<td>string</td>
			<td><pre lang="json">
"mqtt:\n  # Required: host name\n  host: mqtt.server.com\n  # Optional: port (default: shown below)\n  port: 1883\n  # Optional: topic prefix (default: shown below)\n  # WARNING: must be unique if you are running multiple instances\n  topic_prefix: frigate\n  # Optional: client id (default: shown below)\n  # WARNING: must be unique if you are running multiple instances\n  client_id: frigate\n  # Optional: user\n  user: mqtt_user\n  # Optional: password\n  # NOTE: Environment variables that begin with 'FRIGATE_' may be referenced in {}.\n  #       eg. password: '{FRIGATE_MQTT_PASSWORD}'\n  password: password\n  # Optional: interval in seconds for publishing stats (default: shown below)\n  stats_interval: 60\n\ndetectors:\n  # coral:\n  #   type: edgetpu\n  #   device: usb\n  cpu1:\n    type: cpu\n\n# cameras:\n#   # Name of your camera\n#   front_door:\n#     ffmpeg:\n#       inputs:\n#         - path: rtsp://{FRIGATE_RTSP_USERNAME}:{FRIGATE_RTSP_PASSWORD}@10.0.10.10:554/cam/realmonitor?channel=1\u0026subtype=2\n#           roles:\n#             - detect\n#             - rtmp\n#     width: 1280\n#     height: 720\n#     fps: 5\n"
</pre>
</td>
			<td>frigate configuration - see [Docs](https://docs.frigate.video/configuration/index) for more info. Can be given as a `|`-block string (as below) or as a native YAML map - both are supported</td>
		</tr>
		<tr>
			<td>coral.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>enables the use of a Coral device</td>
		</tr>
		<tr>
			<td>coral.hostPath</td>
			<td>string</td>
			<td><pre lang="json">
"/dev/bus/usb"
</pre>
</td>
			<td>path on the host to which to mount the Coral device</td>
		</tr>
		<tr>
			<td>dnsConfig</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Optional pod-level dnsConfig (e.g. to tune ndots). See https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config</td>
		</tr>
		<tr>
			<td>env</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>additional ENV variables to set. Prefix with FRIGATE_ to target Frigate configuration values</td>
		</tr>
		<tr>
			<td>envFromSecrets</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>set environment variables from Secret(s)</td>
		</tr>
		<tr>
			<td>extraInitContainers</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Define extra init containers</td>
		</tr>
		<tr>
			<td>extraVolumeMounts</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>declare additional volume mounts</td>
		</tr>
		<tr>
			<td>extraVolumes</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>declare extra volumes to use for Frigate</td>
		</tr>
		<tr>
			<td>fullnameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Overrides the Full Name of resources</td>
		</tr>
		<tr>
			<td>gpu.nvidia.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables NVIDIA GPU compatibility. Requires a Frigate image built with NVIDIA/TensorRT support and the NVIDIA device plugin/runtime installed on the node - see https://github.com/blakeblackshear/frigate/pkgs/container/frigate for available tags</td>
		</tr>
		<tr>
			<td>gpu.nvidia.runtimeClassName</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Overrides the default runtimeClassName</td>
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
			<td>Expose Frigate via a Gateway API HTTPRoute instead of an Ingress. Requires the Gateway API CRDs and a Gateway to already exist in the cluster. Mutually exclusive with ingress.enabled</td>
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
    "pathType": "PathPrefix",
    "portName": "http-auth"
  }
]
</pre>
</td>
			<td>Path matches routed to the Frigate service. `portName` is one of the Service's named ports (http, http-auth, rtmp, rtsp, webrtc-tcp, webrtc-udp, go2rtc-admin)</td>
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
			<td>Docker image pull policy</td>
		</tr>
		<tr>
			<td>image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"ghcr.io/blakeblackshear/frigate"
</pre>
</td>
			<td>Docker registry/repository to pull the image from</td>
		</tr>
		<tr>
			<td>image.tag</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Overrides the default tag (appVersion) used in Chart.yaml. See available tags at https://github.com/blakeblackshear/frigate/pkgs/container/frigate</td>
		</tr>
		<tr>
			<td>imagePullSecrets</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Docker image pull policy</td>
		</tr>
		<tr>
			<td>ingress.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>annotations to configure your Ingress. See your Ingress Controller's Docs for more info.</td>
		</tr>
		<tr>
			<td>ingress.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables the use of an Ingress Controller to front the Service and can provide HTTPS. Mutually exclusive with httpRoute.enabled</td>
		</tr>
		<tr>
			<td>ingress.hosts</td>
			<td>list</td>
			<td><pre lang="json">
[
  {
    "host": "chart.example.local",
    "paths": [
      {
        "path": "/",
        "portName": "http-auth"
      }
    ]
  }
]
</pre>
</td>
			<td>alternatively use `http` if anonymous auth is allowed</td>
		</tr>
		<tr>
			<td>ingress.ingressClassName</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>ingressClassName for using on clusters with multiple ingresses, default is null</td>
		</tr>
		<tr>
			<td>ingress.tls</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>list of TLS configurations</td>
		</tr>
		<tr>
			<td>nameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Overrides the name of resources</td>
		</tr>
		<tr>
			<td>nodeSelector</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Node Selector configuration</td>
		</tr>
		<tr>
			<td>persistence.config.accessMode</td>
			<td>string</td>
			<td><pre lang="json">
"ReadWriteOnce"
</pre>
</td>
			<td>[access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use for the PVC</td>
		</tr>
		<tr>
			<td>persistence.config.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables persistence for the config directory</td>
		</tr>
		<tr>
			<td>persistence.config.ephemeralWritableConfigYaml</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.config.seedOnly</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>When true (and ephemeralWritableConfigYaml/persistence.config.enabled are both true), only seed config.yml from the ConfigMap if it doesn't already exist on the PVC, instead of overwriting it on every pod start. This lets Frigate's UI make changes that actually persist across restarts. The pod won't be restarted on values.config changes either, since they wouldn't take effect once seeded</td>
		</tr>
		<tr>
			<td>persistence.config.size</td>
			<td>string</td>
			<td><pre lang="json">
"100Mi"
</pre>
</td>
			<td>size/capacity of the PVC</td>
		</tr>
		<tr>
			<td>persistence.config.skipuninstall</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Do not delete the pvc upon helm uninstall</td>
		</tr>
		<tr>
			<td>persistence.data.accessMode</td>
			<td>string</td>
			<td><pre lang="json">
"ReadWriteOnce"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.data.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.data.size</td>
			<td>string</td>
			<td><pre lang="json">
"10Gi"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.data.skipuninstall</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.media.accessMode</td>
			<td>string</td>
			<td><pre lang="json">
"ReadWriteOnce"
</pre>
</td>
			<td>[access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use for the PVC</td>
		</tr>
		<tr>
			<td>persistence.media.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables persistence for the media directory</td>
		</tr>
		<tr>
			<td>persistence.media.size</td>
			<td>string</td>
			<td><pre lang="json">
"10Gi"
</pre>
</td>
			<td>size/capacity of the PVC</td>
		</tr>
		<tr>
			<td>persistence.media.skipuninstall</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Do not delete the pvc upon helm uninstall</td>
		</tr>
		<tr>
			<td>podAnnotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Set additional pod Annotations</td>
		</tr>
		<tr>
			<td>podSecurityContext</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>will override it for frigate container</td>
		</tr>
		<tr>
			<td>priorityClassName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Name of a PriorityClass to assign to the Pod. Leave empty for no priority (default scheduling)</td>
		</tr>
		<tr>
			<td>probes.liveness.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.liveness.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.liveness.initialDelaySeconds</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.liveness.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
10
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.initialDelaySeconds</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.readiness.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
10
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.startup.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.startup.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>probes.startup.periodSeconds</td>
			<td>int</td>
			<td><pre lang="json">
10
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
			<td>Set resource limits/requests for the Pod(s)</td>
		</tr>
		<tr>
			<td>securityContext</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Set Frigate Container Security Context</td>
		</tr>
		<tr>
			<td>service.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.ipFamilies</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.ipFamilyPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"SingleStack"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>service.loadBalancerIP</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Set specific IP address for LoadBalancer. `service.type` must be set to `LoadBalancer`</td>
		</tr>
		<tr>
			<td>service.port</td>
			<td>int</td>
			<td><pre lang="json">
5000
</pre>
</td>
			<td>Port the Service should communicate on</td>
		</tr>
		<tr>
			<td>service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td>Type of Service to use</td>
		</tr>
		<tr>
			<td>shmSize</td>
			<td>string</td>
			<td><pre lang="json">
"1Gi"
</pre>
</td>
			<td>amount of shared memory to use for caching</td>
		</tr>
		<tr>
			<td>strategyType</td>
			<td>string</td>
			<td><pre lang="json">
"Recreate"
</pre>
</td>
			<td>upgrade strategy type (e.g. Recreate or RollingUpdate)</td>
		</tr>
		<tr>
			<td>tmpfs</td>
			<td>object</td>
			<td><pre lang="json">
{
  "enabled": true,
  "sizeLimit": "1Gi"
}
</pre>
</td>
			<td>use memory for tmpfs (mounted to /tmp)</td>
		</tr>
		<tr>
			<td>tolerations</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Node toleration configuration</td>
		</tr>
	</tbody>
</table>

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
