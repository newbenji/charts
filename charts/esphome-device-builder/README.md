
# esphome-device-builder

Web dashboard for building, flashing, and managing ESPHome firmware on ESP8266/ESP32 devices

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2026.7.4](https://img.shields.io/badge/AppVersion-2026.7.4-informational?style=flat-square)

This chart installs the [ESPHome Device Builder](https://github.com/esphome/device-builder) dashboard on Kubernetes, for building and flashing ESPHome firmware to ESP8266/ESP32 devices. As of ESPHome 2026.6.0, this is the dashboard bundled in the standard `ghcr.io/esphome/esphome` image.

## Recovered chart

This chart's original source repository was lost; it was recovered from a
package still hosted on an old devel ChartMuseum instance and republished
here going forward. Beyond this repo's standard chart scaffolding, it's had
persistence, Gateway API support, and an appVersion bump added on top of the
original port — see the changelog below.

Note: the chart uses `hostNetwork: true`, which the dashboard needs to discover devices on the local network for flashing.

### Persistence

Set `persistence.config.enabled: true` before relying on this in anything but
a throwaway environment — without it, every device configuration, secret,
and dashboard setting lives only in the pod's ephemeral filesystem and is
lost on restart. `persistence.cache.enabled: true` is optional but speeds up
compiles by keeping PlatformIO's downloaded toolchains around across
restarts too.

### Running behind an Ingress or HTTPRoute

The dashboard checks that a WebSocket handshake's `Origin` matches the
`Host` header it receives, and 403s the connection otherwise. Most ingress
controllers forward the original `Host` unchanged, so this generally works
out of the box — but if yours rewrites it (or you're proxying a mismatched
hostname), set `env.ESPHOME_TRUSTED_DOMAINS` to the public hostname. See the
[Device Builder docs](https://github.com/esphome/device-builder#behind-a-reverse-proxy)
for details.

## Installing the Chart

This chart is published two ways: as a classic Helm repo via GitHub Pages
(releases only), and as an OCI artifact via the GitHub Container Registry
(releases and alpha builds).

Via the classic repo:

```console
$ helm repo add newbenji-charts https://newbenji.github.io/charts/
$ helm repo update
$ helm install my-release newbenji-charts/esphome-device-builder --version 0.1.0
```

Via OCI:

```console
$ helm install my-release oci://ghcr.io/newbenji/charts/esphome-device-builder --version 0.1.0
```

To just download the chart package:

```console
$ helm pull oci://ghcr.io/newbenji/charts/esphome-device-builder --version 0.1.0
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| newbenji | <benji@newbenji.dk> |  |

## Source Code

* <https://github.com/esphome/esphome>
* <https://github.com/esphome/device-builder>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Set Pod affinity rules |
| env | object | `{}` | additional ENV variables to set, e.g. ESPHOME_TRUSTED_DOMAINS when running behind an ingress/httpRoute that doesn't forward the original Host header, or ESPHOME_USERNAME (paired with ESPHOME_PASSWORD, normally via envFromSecrets) to enable the dashboard's built-in auth gate. See https://github.com/esphome/device-builder#readme |
| envFromSecrets | list | `[]` | set environment variables from Secret(s), e.g. for ESPHOME_USERNAME/ESPHOME_PASSWORD |
| fullnameOverride | string | `""` | Overrides the Full Name of resources |
| httpRoute.annotations | object | `{}` | Annotations to add to the HTTPRoute |
| httpRoute.enabled | bool | `false` | Expose the dashboard via a Gateway API HTTPRoute instead of an Ingress. Requires the Gateway API CRDs and a Gateway to already exist in the cluster. Mutually exclusive with ingress.enabled |
| httpRoute.hostnames | list | `[]` | Hostnames the route matches. Leave empty to match all hostnames on the parent Gateway listener(s) |
| httpRoute.labels | object | `{}` | Additional labels to add to the HTTPRoute |
| httpRoute.matches | list | `[{"path":"/","pathType":"PathPrefix"}]` | Path matches routed to the dashboard Service |
| httpRoute.parentRefs | list | `[{"name":""}]` | References to the Gateway(s) this route attaches to |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.repository | string | `"ghcr.io/esphome/esphome"` | Docker registry/repository to pull the image from |
| image.tag | string | `""` | Overrides the default tag (appVersion) used in Chart.yaml. Defaults to the chart's appVersion (2026.7.4) when left empty. See available tags at https://github.com/esphome/esphome/pkgs/container/esphome |
| imagePullSecrets | list | `[]` | Docker image pull secrets |
| ingress.annotations | object | `{}` | annotations to configure your Ingress. See your Ingress Controller's Docs for more info. |
| ingress.className | string | `""` | ingressClassName for using on clusters with multiple ingresses, default is null |
| ingress.enabled | bool | `false` | Enables the use of an Ingress Controller to front the Service and can provide HTTPS. Mutually exclusive with httpRoute.enabled |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | list of hosts and their paths that the ingress controller should respond to. Each path may also set `pathType` (defaults to `ImplementationSpecific` when unset) |
| ingress.tls | list | `[]` | list of TLS configurations |
| nameOverride | string | `""` | Overrides the name of resources |
| nodeSelector | object | `{}` | Node Selector configuration |
| persistence.cache.accessMode | string | `"ReadWriteOnce"` | access mode to use for the PVC |
| persistence.cache.enabled | bool | `false` | Enables persistence for /cache (PlatformIO's toolchain/platform downloads), so compiles don't re-download them after every pod restart. Without it, the cache falls back to living under /config instead |
| persistence.cache.existingClaim | string | `""` | Use an existing PVC instead of creating one |
| persistence.cache.size | string | `"2Gi"` | size/capacity of the PVC |
| persistence.cache.skipuninstall | bool | `false` | do not delete the PVC upon helm uninstall |
| persistence.cache.storageClass | string | `""` | storageClassName for the PVC. Leave empty to use the cluster default |
| persistence.config.accessMode | string | `"ReadWriteOnce"` | access mode to use for the PVC |
| persistence.config.enabled | bool | `false` | Enables persistence for /config, which holds every device YAML config, secrets, and the dashboard's own state. Without it, all of that is lost whenever the pod restarts. Strongly recommended |
| persistence.config.existingClaim | string | `""` | Use an existing PVC instead of creating one |
| persistence.config.size | string | `"1Gi"` | size/capacity of the PVC |
| persistence.config.skipuninstall | bool | `false` | do not delete the PVC upon helm uninstall |
| persistence.config.storageClass | string | `""` | storageClassName for the PVC. Leave empty to use the cluster default |
| podAnnotations | object | `{}` | Set additional pod Annotations |
| podSecurityContext | object | `{}` | Set Pod level Security Context. The container level security context defined below will override it |
| replicaCount | int | `1` | Number of replicas to run. The dashboard keeps no shared state between replicas, so anything beyond 1 requires a shared persistence.config volume with a ReadWriteMany access mode |
| resources | object | `{}` | Set resource limits/requests for the Pod |
| securityContext | object | `{}` | Set Container Security Context |
| service.port | int | `80` | Port the Service should communicate on |
| service.type | string | `"ClusterIP"` | Type of Service to use |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Node toleration configuration |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
