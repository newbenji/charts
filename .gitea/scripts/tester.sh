#!/usr/bin/env bash

# https://github.com/helm/chart-releaser-action/blob/main/cr.sh

set -o errexit
set -o nounset
set -o pipefail

echo "Tester BASH SCRIPT"




main () {

    local charts_dir=charts
    local repo_root
    local latest_tag
    local skip_packaging=false
    local mark_as_latest=true

    repo_root=$(git rev-parse --show-toplevel)
    pushd "$repo_root" > /dev/null

    latest_tag=$(lookup_latest_tag)

    local changed_charts=()

    echo "Discovering changed charts since '$latest_tag'..."
    readarray -t changed_charts <<< "$(lookup_changed_charts "$latest_tag")"

    echo "Changed dirs: ${changed_charts[*]}"

     for chart in "${changed_charts[@]}"; do
                if [[ -d "$chart" ]]; then
                    lint_chart "$chart"
                else
                    echo "Chart '$chart' no longer exists in repo. Skipping it..."
                fi
            done

    popd > /dev/null
}


lint_chart() {
    local chart="$1"
    echo "in lint"
    echo "${chart}"

    local args=("$chart" --package-path .cr-release-packages)
    # if [[ -n "$config" ]]; then
        # args+=(--config "$config")
#    0 fi

    # echo "Packaging chart '$chart'..."
    # cr package "${args[@]}"
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
    echo ""
    local fields="1-${depth}"
    # local fields="2-"
    echo "fields: ${fields[*]}"
    echo  ""
    cut -d '/' -f "$fields" <<< "$changed_files" | uniq | filter_charts
}

show_help() {
cat << EOF
Usage: $(basename "$0") <options>
    -h, --help               Display help
    -d, --charts-dir         The charts directory (default: charts)
    -s, --skip-packaging     Skip the packaging step (run your own packaging before using the releaser)
    -l, --mark-as-latest     Mark the created GitHub release as 'latest' (default: false)
EOF
}

parse_command_line() {
    while :; do
        case "${1:-}" in
            -h|--help)
                show_help
                exit
                ;;
            -d|--charts-dir)
                if [[ -n "${2:-}" ]]; then
                    charts_dir="$2"
                    shift
                else
                    echo "ERROR: '-d|--charts-dir' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -s|--skip-packaging)
                if [[ -n "${2:-}" ]]; then
                    skip_packaging="$2"
                    shift
                fi
                ;;
            -l|--mark-as-latest)
                if [[ -n "${2:-}" ]]; then
                    mark_as_latest="$2"
                    shift
                fi
                ;;
            *)
                break
                ;;
        esac

        shift
    done
}

main "$@"