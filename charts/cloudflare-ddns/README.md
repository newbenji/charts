
# cloudflare-ddns

Cloudflare DDNS updater (favonia/cloudflare-ddns) - keeps Cloudflare DNS records pointed at the current public IP of the network the cluster runs in

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.17.1](https://img.shields.io/badge/AppVersion-1.17.1-informational?style=flat-square)

This chart runs [favonia/cloudflare-ddns](https://github.com/favonia/cloudflare-ddns), a small updater that
detects the public IP address of the network it runs in and keeps Cloudflare
DNS records pointed at it. Upstream ships only the container image (its
Kubernetes manifests are no longer maintained); this chart is the Deployment
around it.

## API token

Create a Cloudflare API token with **Zone - DNS - Edit**, scoped to the
zone(s) of the managed domains. Nothing else is needed.

Either pass it inline (`cloudflare.apiToken`, the chart stores it in a
Secret), or reference a Secret you manage yourself (`cloudflare.existingSecret`).
Set exactly one. The token is mounted as a file and read through
`CLOUDFLARE_API_TOKEN_FILE`, so it never shows up in the process environment.

With GitOps, keep the token out of plain-text values: for example a
SOPS-encrypted values file (helm-secrets) for `cloudflare.apiToken`, or an
external-secrets / sealed-secrets object for `cloudflare.existingSecret`.

## Which records

`domains` are managed for A and AAAA, `ip4Domains` / `ip6Domains` for one
family only. Wildcards (`*.example.com`) work. The updater only touches the
listed names; other records in the zone are left alone.

If the records must not get AAAA records (e.g. the cluster's pods have no
IPv6, or IPv6 isn't published on purpose), set `ip6Provider: none`.

## Detection from inside the cluster

The default provider (`cloudflare.trace`) asks Cloudflare which address the
request came from, so it sees the address the cluster's outbound traffic is
NATed to. That is what you want for a home network behind a single public IP.
Providers that read a local interface address (`local`, `local.iface`) need
`hostNetwork: true`.

## Only one updater

The Deployment always runs one replica with the `Recreate` strategy, so two
updaters never race on the same records. `deleteOnStop` stays off by default:
with it on, every pod restart or rollout would briefly delete the records.

## Installing the Chart

This chart is published two ways: as a classic Helm repo via GitHub Pages
(releases only), and as an OCI artifact via the GitHub Container Registry
(releases and alpha builds).

Via the classic repo:

```console
$ helm repo add newbenji-charts https://newbenji.github.io/charts/
$ helm repo update
$ helm install my-release newbenji-charts/cloudflare-ddns --version 0.1.0
```

Via OCI:

```console
$ helm install my-release oci://ghcr.io/newbenji/charts/cloudflare-ddns --version 0.1.0
```

To just download the chart package:

```console
$ helm pull oci://ghcr.io/newbenji/charts/cloudflare-ddns --version 0.1.0
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| newbenji | <benji@newbenji.dk> |  |

## Source Code

* <https://github.com/favonia/cloudflare-ddns>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment |
| cloudflare.apiToken | string | `""` | Cloudflare API token. The chart stores it in a Secret. Needs only `Zone - DNS - Edit` on the zone(s) of the managed domains. Leave empty when using `cloudflare.existingSecret` |
| cloudflare.existingSecret.key | string | `"api-token"` | Key in that Secret holding the token |
| cloudflare.existingSecret.name | string | `""` | Name of an existing Secret holding the API token. Takes the place of `cloudflare.apiToken`; set exactly one of the two |
| commonAnnotations | object | `{}` | Annotations added to every resource the chart creates |
| commonLabels | object | `{}` | Labels added to every resource the chart creates |
| deleteOnStop | bool | `false` | Delete the managed records when the updater stops (`DELETE_ON_STOP`). Keep this off in Kubernetes: every pod restart or rollout would briefly remove the records |
| deploymentAnnotations | object | `{}` | Annotations to add to the Deployment |
| domains | list | `[]` | Domains whose A and AAAA records are managed (`DOMAINS`). Wildcards like `*.example.com` are supported. At least one of `domains`, `ip4Domains` or `ip6Domains` must be set |
| emoji | bool | `false` | Emoji in log lines (`EMOJI`). Off by default so log collectors get plain text |
| extraEnv | list | `[]` | Extra environment variables for the container, e.g. `HEALTHCHECKS` / `UPTIMEKUMA` monitoring URLs (put those in a Secret and use `valueFrom`) |
| fullnameOverride | string | `""` | Overrides the Full Name of resources |
| hostNetwork | bool | `false` | Run the pod in the node's network namespace. Only needed for the `local` / `local.iface` IP providers |
| image.digest | string | `""` | Pin the image by digest (e.g. `sha256:...`). When set, it's used in addition to the tag (`repo:tag@digest`), so the tag stays readable but can't be silently re-pointed |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.repository | string | `"favonia/cloudflare-ddns"` | Docker registry/repository to pull the image from |
| image.tag | string | `""` | Overrides the default tag (appVersion) used in Chart.yaml. Defaults to the chart's appVersion (1.17.1) when left empty. See available tags at https://hub.docker.com/r/favonia/cloudflare-ddns/tags |
| imagePullSecrets | list | `[]` | Docker image pull secrets |
| ip4Domains | list | `[]` | Extra domains managed for A (IPv4) records only (`IP4_DOMAINS`) |
| ip4Provider | string | `"cloudflare.trace"` | How the public IPv4 address is detected (`IP4_PROVIDER`), e.g. `cloudflare.trace`, `cloudflare.doh`, `url:<url>`, or `none` to not manage A records. `local` needs `hostNetwork: true` |
| ip6Domains | list | `[]` | Extra domains managed for AAAA (IPv6) records only (`IP6_DOMAINS`) |
| ip6Provider | string | `"cloudflare.trace"` | How the public IPv6 address is detected (`IP6_PROVIDER`). Set to `none` to not manage AAAA records, e.g. when pods have no IPv6 or the records shouldn't be published |
| managedRecordsCommentRegex | string | `""` | Only manage existing records whose comment matches this RE2 regex (`MANAGED_RECORDS_COMMENT_REGEX`). Empty means all records of the listed domains |
| nameOverride | string | `""` | Overrides the name of resources |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to add to the pod |
| podLabels | object | `{}` | Labels to add to the pod |
| podSecurityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod-level security context. The image runs as any non-root UID; fsGroup makes the mounted token file readable |
| priorityClassName | string | `""` | Priority class for the pod |
| proxied | string | `"false"` | Proxy status for the records (`PROXIED`): `true`, `false`, or a domain expression (see the upstream docs) |
| quiet | bool | `false` | Reduce logging to errors and changes (`QUIET`) |
| recordComment | string | `""` | Comment set on records the updater creates (`RECORD_COMMENT`) |
| resources | object | `{"limits":{"memory":"64Mi"},"requests":{"cpu":"5m","memory":"16Mi"}}` | Resource requests and limits. The updater is a small Go binary that sleeps between checks |
| revisionHistoryLimit | int | `3` | Number of old ReplicaSets to keep for rollback |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container-level security context |
| timezone | string | `"UTC"` | Timezone for log timestamps and cron parsing (`TZ`) |
| tolerations | list | `[]` | Tolerations for pod assignment |
| ttl | int | `1` | TTL in seconds for the records (`TTL`). `1` means automatic |
| updateCron | string | `"@every 5m"` | Update schedule (`UPDATE_CRON`): a cron expression, `@every <duration>`, or `@once` |
| updateOnStart | bool | `true` | Check and update immediately on start (`UPDATE_ON_START`) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
