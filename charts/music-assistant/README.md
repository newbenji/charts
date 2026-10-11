
# music-assistant

Music Assistant server - a music library manager that connects your streaming services to a wide range of connected speakers (Chromecast/Google Cast, AirPlay, Sonos, DLNA, Squeezebox, ...)

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.10.6](https://img.shields.io/badge/AppVersion-2.10.6-informational?style=flat-square)

This chart installs the [Music Assistant](https://music-assistant.io/) server on Kubernetes. Upstream only
supports running it as a standalone, host-networked container; this chart
keeps that model (one host-networked pod) and adds the Kubernetes pieces
around it: a Service, an optional Ingress/HTTPRoute, persistence, and probes.

## Networking

The pod runs with `hostNetwork: true` by default, and that's required for
normal use, for two reasons:

- **Player discovery** (Chromecast/Google Cast, AirPlay, Sonos, DLNA, ...) is
  mDNS/SSDP multicast on the LAN, which doesn't cross pod networking.
- **Streaming is pull-based.** Music Assistant hands each speaker a URL on
  its own LAN address and the streamserver port (8097 by default), and the
  speaker fetches the audio from there.

Consequences:

- Ports `8095` (web UI/API) and `8097` (stream) are bound on the node. They
  must be free on every node the pod can be scheduled on. Use `nodeSelector`/`affinity` to
  restrict that set if needed.
- If the pod moves to another node, Music Assistant picks up the new node's
  address by itself. Playback in progress at that moment stops, and
  speakers are rediscovered within a few seconds.
- `dnsPolicy` defaults to `ClusterFirstWithHostNet`, so the server can still
  resolve in-cluster Service names (e.g. Home Assistant's).

A ClusterIP **Service** is always created for port 8095. It's the stable
address for in-cluster clients and the backend for the Ingress/HTTPRoute.
Speakers don't use it.

## Connecting Home Assistant

Add the **Music Assistant** integration in Home Assistant and point it at the
Service:

```
http://<release-fullname>.<namespace>.svc.cluster.local:8095
```

If Home Assistant itself runs with `hostNetwork: true`, it needs
`dnsPolicy: ClusterFirstWithHostNet` to resolve that name. Music Assistant
2.7+ requires authentication; the integration's config flow takes care of
logging in.

## Web UI behind an Ingress / HTTPRoute

The UI keeps a long-lived WebSocket open to `/ws`. With ingress-nginx, raise
the proxy timeouts so idle sessions aren't cut every 60s:

```yaml
ingress:
  annotations:
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
```

Note that with host networking, port 8095 is also reachable directly on the
node's address regardless of the Ingress, so an Ingress-level IP allowlist
doesn't restrict it. Music Assistant's own login does.

## Persistence

`/data` holds the library database, provider logins (e.g. Spotify), and all
settings, plus the artwork/metadata cache under `/data/.cache`. It's enabled by
default and kept on uninstall (`persistence.data.skipuninstall`). Music
Assistant uses SQLite, so block storage is preferable to NFS where you have
the choice.

For a local music library, enable `persistence.media` with either an existing
PVC or an NFS export. It's mounted read-only at `/media` and used through the
Filesystem (local disk) provider. Mounting SMB/NFS shares from *inside* Music
Assistant instead requires extra capabilities. See `securityContext` in the
values below.

## Upgrades

Pin `image.tag` (or rely on the chart's appVersion) rather than `latest`, so a
pod restart never upgrades the server unexpectedly. Don't switch an existing
install between the stable and `beta` image channels: upstream doesn't support
moving a database between them.

## Installing the Chart

This chart is published two ways: as a classic Helm repo via GitHub Pages
(releases only), and as an OCI artifact via the GitHub Container Registry
(releases and alpha builds).

Via the classic repo:

```console
$ helm repo add newbenji-charts https://newbenji.github.io/charts/
$ helm repo update
$ helm install my-release newbenji-charts/music-assistant --version 0.1.0
```

Via OCI:

```console
$ helm install my-release oci://ghcr.io/newbenji/charts/music-assistant --version 0.1.0
```

To just download the chart package:

```console
$ helm pull oci://ghcr.io/newbenji/charts/music-assistant --version 0.1.0
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| newbenji | <benji@newbenji.dk> |  |

## Source Code

* <https://github.com/music-assistant/server>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Set Pod affinity rules |
| commonAnnotations | object | `{}` | Annotations added to every resource the chart creates |
| commonLabels | object | `{}` | Labels added to every resource the chart creates |
| deploymentAnnotations | object | `{}` | Annotations to add to the Deployment |
| dnsPolicy | string | `""` | DNS policy for the pod. `ClusterFirstWithHostNet` keeps cluster DNS (Service names) resolvable while on the host network; plain `ClusterFirst` silently falls back to the node's resolv.conf when hostNetwork is on. Leave empty to use `ClusterFirstWithHostNet` with hostNetwork and `ClusterFirst` without |
| env | object | `{}` | Additional environment variables, as a name/value map |
| envFromSecrets | list | `[]` | Set environment variables from Secret(s) |
| extraContainers | list | `[]` | Sidecar containers to run next to Music Assistant (rendered with tpl), e.g. a snapserver or a backup agent |
| extraEnv | list | `[]` | Additional environment variables in full Kubernetes EnvVar form (e.g. for valueFrom) |
| extraManifests | list | `[]` | Extra Kubernetes manifests to deploy with the release (list or map of objects or YAML strings, rendered with tpl), e.g. an ExternalSecret or a backup schedule for the /data PVC |
| extraVolumeMounts | list | `[]` | Additional volume mounts to add to the container |
| extraVolumes | list | `[]` | Additional volumes to add to the pod |
| fullnameOverride | string | `""` | Overrides the Full Name of resources |
| hostAliases | list | `[]` | Extra /etc/hosts entries for the pod, e.g. to reach a NAS or speaker by a name your DNS doesn't serve |
| hostNetwork | bool | `true` | Run the pod in the node's network namespace. Upstream only supports host (or macvlan) networking: player discovery (mDNS/SSDP for Chromecast, AirPlay, Sonos, DLNA, ...) is multicast and the speakers pull audio back from the server's own LAN address, neither of which works through pod networking. Only turn this off if you attach the pod to the LAN another way (e.g. Multus/macvlan via podAnnotations) |
| httpRoute.annotations | object | `{}` | Annotations to add to the HTTPRoute |
| httpRoute.enabled | bool | `false` | Expose the web UI via a Gateway API HTTPRoute instead of an Ingress. Requires the Gateway API CRDs and a Gateway to already exist in the cluster. Mutually exclusive with ingress.enabled |
| httpRoute.hostnames | list | `[]` | Hostnames the route matches. Leave empty to match all hostnames on the parent Gateway listener(s) |
| httpRoute.labels | object | `{}` | Additional labels to add to the HTTPRoute |
| httpRoute.matches | list | `[{"path":"/","pathType":"PathPrefix"}]` | Path matches routed to the web UI Service |
| httpRoute.parentRefs | list | `[{"name":""}]` | References to the Gateway(s) this route attaches to |
| image.digest | string | `""` | Pin the image by digest (e.g. `sha256:...`). When set, it's used in addition to the tag (`repo:tag@digest`), so the tag stays readable but can't be silently re-pointed |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.repository | string | `"ghcr.io/music-assistant/server"` | Docker registry/repository to pull the image from |
| image.tag | string | `""` | Overrides the default tag (appVersion) used in Chart.yaml. Defaults to the chart's appVersion (2.10.6) when left empty. Don't switch an existing install between the stable and `beta` channels by changing the tag - upstream doesn't support moving a database between channels. See available tags at https://github.com/music-assistant/server/pkgs/container/server |
| imagePullSecrets | list | `[]` | Docker image pull secrets |
| ingress.annotations | object | `{}` | annotations to configure your Ingress. See your Ingress Controller's Docs for more info. |
| ingress.className | string | `""` | ingressClassName for using on clusters with multiple ingresses, default is null |
| ingress.enabled | bool | `false` | Enables the use of an Ingress Controller to front the web UI and can provide HTTPS. Mutually exclusive with httpRoute.enabled. The UI uses a long-lived WebSocket (/ws), so raise your controller's proxy read/send timeouts (e.g. `nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"`) |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | list of hosts and their paths that the ingress controller should respond to. Each path may also set `pathType` (defaults to `ImplementationSpecific` when unset) |
| ingress.tls | list | `[]` | list of TLS configurations |
| initContainers | list | `[]` | Init containers to run before Music Assistant starts (rendered with tpl) |
| lifecycle | object | `{}` | Lifecycle hooks for the Music Assistant container |
| logLevel | string | `"info"` | Log level passed as LOG_LEVEL (critical, error, warning, info, debug) |
| nameOverride | string | `""` | Overrides the name of resources |
| nodeSelector | object | `{}` | Node Selector configuration |
| persistence.data.accessMode | string | `"ReadWriteOnce"` | access mode to use for the PVC |
| persistence.data.annotations | object | `{}` | Annotations to add to the PVC, e.g. for a backup tool |
| persistence.data.enabled | bool | `true` | Enables persistence for /data, which holds the library database, provider logins (e.g. Spotify), player and core settings. Without it, everything is lost whenever the pod restarts. Strongly recommended. Music Assistant keeps SQLite databases here, so prefer block storage (iSCSI, Longhorn, local) over NFS where you can |
| persistence.data.existingClaim | string | `""` | Use an existing PVC instead of creating one |
| persistence.data.size | string | `"2Gi"` | size/capacity of the PVC. Artwork/metadata cache lives here too (/data/.cache), so large libraries need more |
| persistence.data.skipuninstall | bool | `true` | Keep the PVC when the release is uninstalled (sets helm.sh/resource-policy: keep) |
| persistence.data.storageClass | string | `""` | storageClassName for the PVC. Leave empty to use the cluster default, `-` to disable dynamic provisioning |
| persistence.media.enabled | bool | `false` | Mount a local music library at /media, for the Filesystem (local disk) music provider |
| persistence.media.existingClaim | string | `""` | Existing PVC to mount. Takes precedence over `nfs` |
| persistence.media.mountPath | string | `"/media"` | Path the library is mounted at inside the container |
| persistence.media.nfs | object | `{}` | Mount an NFS export directly instead of a PVC, e.g. `{server: nas.lan, path: /volume1/music}` |
| persistence.media.readOnly | bool | `true` | Mount the library read-only, as upstream recommends |
| podAnnotations | object | `{}` | Set additional pod annotations |
| podLabels | object | `{}` | Set additional pod labels |
| podSecurityContext | object | `{}` | Set Pod level Security Context. The container level security context defined below will override it |
| ports.stream | int | `8097` | Port the built-in streamserver listens on, which players pull audio from. Configured in the Music Assistant UI (Settings > Core > Streamserver), not by this chart - this value only documents/exposes it. With hostNetwork this port must be free on every node the pod can be scheduled on (Music Assistant moves on to the next free port if it isn't) |
| ports.web | int | `8095` | Port the web UI/API listens on. Music Assistant always binds 8095; only change this if you've changed it upstream too. With hostNetwork this port must be free on every node the pod can be scheduled on |
| priorityClassName | string | `""` | Priority class name for the pod |
| probes.liveness | object | `{"failureThreshold":3,"httpGet":{"path":"/info","port":"http"},"periodSeconds":30,"timeoutSeconds":10}` | Liveness probe |
| probes.readiness | object | `{"failureThreshold":3,"httpGet":{"path":"/info","port":"http"},"periodSeconds":10,"timeoutSeconds":5}` | Readiness probe |
| probes.startup | object | `{"failureThreshold":30,"httpGet":{"path":"/info","port":"http"},"periodSeconds":10,"timeoutSeconds":5}` | Startup probe. Music Assistant loads all providers before its webserver answers, which can take a while on first start or with large libraries, so this allows up to 5 minutes. Probes hit /info, the same lightweight unauthenticated endpoint the Home Assistant integration uses |
| resources | object | `{}` | Set resource limits/requests for the Pod. Upstream asks for at least 2GB of RAM available to the server; actual usage is usually well below that, but transcoding and large library syncs can spike |
| revisionHistoryLimit | int | `3` | Number of old ReplicaSets to keep for rollback |
| runtimeClassName | string | `""` | RuntimeClass for the pod (e.g. a gVisor/Kata class). Leave empty for the cluster default |
| securityContext | object | `{}` | Set Container Security Context. The upstream image runs as root. Only if you want Music Assistant itself to mount SMB/NFS shares from inside the container (instead of mounting them via persistence.media), it needs the SYS_ADMIN and DAC_READ_SEARCH capabilities and an unconfined AppArmor profile - which significantly weakens isolation |
| service.annotations | object | `{}` | Annotations to add to the Service |
| service.exposeStreamPort | bool | `false` | Also expose the stream port on the Service. Normally unnecessary: players are handed the server's own LAN address for streams, not the Service's |
| service.port | int | `8095` | Port the Service exposes the web UI/API on |
| service.type | string | `"ClusterIP"` | Type of Service to use. A ClusterIP Service gives in-cluster clients (like the Home Assistant integration) a stable address, `http://<fullname>.<namespace>.svc:<port>`, no matter which node the host-networked pod lands on |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automountServiceAccountToken | bool | `false` | Mount the service account token into the pod. Music Assistant doesn't talk to the Kubernetes API, so this is off by default |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| terminationGracePeriodSeconds | int | `30` | Seconds to wait for a graceful shutdown before the container is killed. Music Assistant flushes its database and stops players on shutdown |
| tests.enabled | bool | `true` | Create the `helm test` pod that checks the Service answers on /info |
| tests.image.repository | string | `"docker.io/library/busybox"` | Image used by the test pod |
| tests.image.tag | string | `"1.37"` | Test image tag |
| timezone | string | `""` | Timezone passed as TZ, e.g. Europe/Copenhagen. Left unset when empty |
| tolerations | list | `[]` | Node toleration configuration |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
