# synology-csi

![Version: 1.1.2](https://img.shields.io/badge/Version-1.1.2-informational?style=flat-square) ![AppVersion: v1.1.1](https://img.shields.io/badge/AppVersion-v1.1.1-informational?style=flat-square)

Installs the Synology CSI Driver...

**Homepage:** <https://github.com/christian-schlichtherle/synology-csi-chart>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Christian Schlichtherle |  | <https://github.com/christian-schlichtherle> |

## Source Code

* <https://github.com/christian-schlichtherle/synology-csi-chart/tree/main>
* <https://github.com/SynologyOpenSource/synology-csi/tree/main>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| connections[0].host | string | `"192.168.1.1"` |  |
| connections[0].https | bool | `false` |  |
| connections[0].password | string | `"password"` |  |
| connections[0].port | int | `5000` |  |
| connections[0].username | string | `"username"` |  |
| fullnameOverride | string | `""` |  |
| images.attacher.image | string | `"k8s.gcr.io/sig-storage/csi-attacher"` |  |
| images.attacher.imagePullPolicy | string | `"IfNotPresent"` |  |
| images.attacher.tag | string | `"v4.2.0"` |  |
| images.nodeDriverRegistrar.image | string | `"k8s.gcr.io/sig-storage/csi-node-driver-registrar"` |  |
| images.nodeDriverRegistrar.imagePullPolicy | string | `"IfNotPresent"` |  |
| images.nodeDriverRegistrar.tag | string | `"v2.6.3"` |  |
| images.plugin.image | string | `"synology/synology-csi"` |  |
| images.plugin.pullPolicy | string | `"IfNotPresent"` |  |
| images.plugin.tag | string | `""` |  |
| images.provisioner.image | string | `"k8s.gcr.io/sig-storage/csi-provisioner"` |  |
| images.provisioner.imagePullPolicy | string | `"IfNotPresent"` |  |
| images.provisioner.tag | string | `"v3.4.0"` |  |
| images.resizer.image | string | `"k8s.gcr.io/sig-storage/csi-resizer"` |  |
| images.resizer.imagePullPolicy | string | `"IfNotPresent"` |  |
| images.resizer.tag | string | `"v1.7.0"` |  |
| images.snapshotter.image | string | `"k8s.gcr.io/sig-storage/csi-snapshotter"` |  |
| images.snapshotter.imagePullPolicy | string | `"IfNotPresent"` |  |
| images.snapshotter.tag | string | `"v6.2.1"` |  |
| installCSIDriver | bool | `true` |  |
| nameOverride | string | `""` |  |
| node.affinity | object | `{}` |  |
| node.nodeSelector | object | `{}` |  |
| node.tolerations | list | `[]` |  |
| s | string | `"ss"` |  |
| snapshotter.affinity | object | `{}` |  |
| snapshotter.nodeSelector | object | `{}` |  |
| snapshotter.tolerations | list | `[]` |  |
| storageClasses.delete.reclaimPolicy | string | `"Delete"` |  |
| storageClasses.retain.reclaimPolicy | string | `"Retain"` |  |
| volumeSnapshotClasses.delete | object | `{}` |  |
| volumeSnapshotClasses.retain.deletionPolicy | string | `"Retain"` |  |
