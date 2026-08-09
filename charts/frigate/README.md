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
| blakeblackshear | blakeb@blakeshome.com |  |
| billimek | jeff@billimek.com |  |
| newbenji | benji@newbenji.dk |  |

## Source Code

* <https://github.com/blakeblackshear/frigate>
* <https://github.com/blakeblackshear/blakeshome-charts>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Set Pod affinity rules |
| config | string | Omitted for brevity. See [values.yaml](./values.yaml). | frigate configuration - see [Docs](https://docs.frigate.video/configuration/index) for more info. Can be given as a `\|`-block string (as below) or as a native YAML map - both are supported |
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
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.repository | string | `"ghcr.io/blakeblackshear/frigate"` | Docker registry/repository to pull the image from |
| image.tag | string | `nil` | Overrides the default tag (appVersion) used in Chart.yaml. See available tags at https://github.com/blakeblackshear/frigate/pkgs/container/frigate |
| imagePullSecrets | list | `[]` | Docker image pull policy |
| httpRoute.annotations | object | `{}` | Annotations to add to the HTTPRoute |
| httpRoute.enabled | bool | `false` | Expose Frigate via a Gateway API HTTPRoute instead of an Ingress. Requires the Gateway API CRDs and a Gateway to already exist in the cluster. Mutually exclusive with ingress.enabled |
| httpRoute.hostnames | list | `[]` | Hostnames the route matches. Leave empty to match all hostnames on the parent Gateway listener(s) |
| httpRoute.labels | object | `{}` | Additional labels to add to the HTTPRoute |
| httpRoute.matches | list | `[{"path":"/","pathType":"PathPrefix","portName":"http-auth"}]` | Path matches routed to the Frigate service. `portName` is one of the Service's named ports (http, http-auth, rtmp, rtsp, webrtc-tcp, webrtc-udp, go2rtc-admin) |
| httpRoute.parentRefs | list | `[{"name":""}]` | References to the Gateway(s) this route attaches to |
| ingress.annotations | object | `{}` | annotations to configure your Ingress. See your Ingress Controller's Docs for more info. |
| ingress.enabled | bool | `false` | Enables the use of an Ingress Controller to front the Service and can provide HTTPS. Mutually exclusive with httpRoute.enabled |
| ingress.hosts | list | `[{"host":"chart.example.local","paths":[{"path":"/","portName":"http-auth"}]}]` | list of hosts and their paths and ports that ingress controller should repsond to. Each path may also set `pathType` (defaults to `ImplementationSpecific` when unset) |
| ingress.ingressClassName | string | `nil` | ingressClassName for using on clusters with multiple ingresses, default is null |
| ingress.tls | list | `[]` | list of TLS configurations |
| nameOverride | string | `""` | Overrides the name of resources |
| nodeSelector | object | `{}` | Node Selector configuration |
| persistence.data.* | | | **This config key is obsolete and should not be used. Use `persistence.media.*` and `persistence.config.*` instead.** |
| persistence.config.enabled | bool | `false` | Enables persistence for the config directory |
| persistence.config.size | string | `"100Mi"` | size/capacity of the PVC |
| persistence.config.skipuninstall | bool | `false` | Do not delete the pvc upon helm uninstall |
| persistence.config.accessMode | string | `"ReadWriteOnce"` | [access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use for the PVC |
| persistence.config.ephemeralWritableConfigYaml | bool | `true` | Copy configMap config into volume to make writable. All live changes are lost when pod restarts unless `seedOnly` is also set |
| persistence.config.seedOnly | bool | `false` | When true (and ephemeralWritableConfigYaml/persistence.config.enabled are both true), only seed config.yml from the ConfigMap if it doesn't already exist on the PVC, instead of overwriting it on every pod start. This lets Frigate's UI make changes that actually persist across restarts |
| persistence.media.enabled | bool | `false` | Enables persistence for the media directory |
| persistence.media.size | string | `"10Gi"` | size/capacity of the PVC |
| persistence.media.skipuninstall | bool | `false` | Do not delete the pvc upon helm uninstall |
| persistence.media.accessMode | string | `"ReadWriteOnce"` | [access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) to use for the PVC |
| podAnnotations | object | `{}` | Set additonal pod Annotations |
| podSecurityContext | object | `{}` | Set Pod level Security Context. The container level security context defined below will override it for the frigate container |
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
| service.labels | object | `{}` |  |
| service.loadBalancerIP | string | `nil` | Set specific IP address for LoadBalancer. `service.type` must be set to `LoadBalancer` |
| service.port | int | `5000` | Port the Service should communicate on |
| service.type | string | `"ClusterIP"` | Type of Service to use |
| shmSize | string | `"1Gi"` | amount of shared memory to use for caching |
| strategyType | string | `"Recreate"` | upgrade strategy type (e.g. Recreate or RollingUpdate) |
| tmpfs.enabled | bool | `true` | use memory for tmpfs (mounted to /tmp) |
| tmpfs.sizeLimit | string | `"1Gi"` |  |
| tolerations | list | `[]` | Node toleration configuration |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
