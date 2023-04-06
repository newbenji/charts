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


}

lookup_latest_tag() {
    git fetch --tags > /dev/null 2>&1

    if ! git describe --tags --abbrev=0 HEAD~ 2> /dev/null; then
        git rev-list --max-parents=0 --first-parent HEAD
    fi
}

main "$@"