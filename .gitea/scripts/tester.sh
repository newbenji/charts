#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "Tester BASH SCRIPT"


main () {

    local charts_dir=charts
    local repo_root
    local latest_tag

    repo_root=$(git rev-parse --show-toplevel)

    latest_tag=$(lookup_latest_tag)

    echo "DIR OF REPO $repo_root"


    local changed_charts=()
    echo "Discovering changed charts since '$latest_tag'..."
    readarray -t changed_charts <<< "$(lookup_changed_charts "$latest_tag")"

    echo "Changed dirs: ${changed_charts[*]}"

}

lookup_latest_tag() {
    git fetch --tags > /dev/null 2>&1

    if ! git describe --tags --abbrev=0 HEAD~ 2> /dev/null; then
        git rev-list --max-parents=0 --first-parent HEAD
    fi
}


filter_charts() {
    while read -r chart; do
        [[ ! -d "$chart" ]] && continue
        local file="$chart/Chart.yaml"
        if [[ -f "$file" ]]; then
            echo "$chart"
        else
           echo "WARNING: $file is missing, assuming that '$chart' is not a Helm chart. Skipping." 1>&2
        fi
    done
}

lookup_changed_charts() {
    local commit="$1"

    local changed_files
    changed_files=$(git diff --find-renames --name-only "$commit" -- "$charts_dir")

    local depth=$(( $(tr "/" "\n" <<< "$charts_dir" | sed '/^\(\.\)*$/d' | wc -l) + 1 ))
    echo "depth: ${depth[*]}"

    local fields="1-${depth}"
    echo "fields: ${fields[*]}"

    cut -d '/' -f "$fields" <<< "$changed_files" | uniq | filter_charts
}

main "$@"