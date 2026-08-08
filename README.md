# charts

Helm charts, published as OCI artifacts to the GitHub Container Registry (no
`helm repo add` — OCI registries don't support the classic Helm repo index).

## Installing a chart

```console
$ helm install my-release oci://ghcr.io/newbenji/charts/<chart-name> --version <version>
```

Or just download the package without installing:

```console
$ helm pull oci://ghcr.io/newbenji/charts/<chart-name> --version <version>
```

Browse available charts and versions at
[github.com/newbenji/charts/pkgs](https://github.com/newbenji/charts?tab=packages),
or see each chart's own README under [`charts/`](charts/) for its specific
values and installation notes.

## Releases vs. alpha builds

- Every push to a branch other than `main` builds and publishes an alpha
  version of any chart changed since `main` (version suffixed `-alpha`, e.g.
  `1.2.0-alpha`). These are for testing in-progress changes and aren't
  guaranteed stable.
- Merging a pull request into `main` publishes the real release, using the
  chart version as committed in the PR.

## Contributing

Changes land on `main` only via pull request (branch protection requires it).
Push your change to a branch, open a PR — CI lints and alpha-builds the
changed charts automatically — and once merged, the release build runs and
publishes the real version.
