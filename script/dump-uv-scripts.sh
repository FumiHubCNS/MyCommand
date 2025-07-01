#!/bin/bash

set -e

PYPROJECT="pyproject.toml"
VENV_BIN=".venv/bin"
USE_NETWORK=false

# === argument selection ===
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --use-network)
            USE_NETWORK=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--use-network]"
            exit 1
            ;;
    esac
done

# === dump script defined by [project.scripts] in pyproject.toml  ===
dump_scripts_section() {
    local file="$1"
    echo "Fetching: $pwd/$1:"
	echo "[project.scripts] from $pwd/$1:"
    awk '
        /^\[project\.scripts\]/ { in_section=1; next }
        /^\[.*\]/ { in_section=0 }
        in_section && /^[^#[:space:]]/ { print "  " $0 }
    ' "$file"
    echo
}

# === dump executable in .venv/bin  ===
dump_venv_executables() {
    if [[ -d "$VENV_BIN" ]]; then
    	echo "Fetching: $pwd/venv/bin:"
        echo "[executables] in .venv/bin:"
		find "$VENV_BIN" -type f -perm +111 -exec basename {} \; | sort | sed 's/^/  /'
    else
        echo ".venv/bin does not exist"
    fi
}

# === get linked uv prohect in github page
dump_github_pyproject_urls() {
    local file="$1"
    local branch="${2:-main}"  # デフォルトブランチ

    sed -n '/^\[tool\.uv\.sources\]/,/^\[.*\]/p' "$file" | \
        grep 'git *= *"https://github.com/' | \
        sed -E 's/.*git *= *"https:\/\/github\.com\/([^"]+)\.git".*/https:\/\/raw.githubusercontent.com\/\1\/'"$branch"'\/pyproject.toml/'
}

fetch_and_dump_scripts_from_urls() {
    local urls=("$@")
    for url in "${urls[@]}"; do
        echo "Fetching: $url"
        tmpfile=$(mktemp)

        if curl -fsSL --max-time 2 "$url" -o "$tmpfile"; then
            echo "[project.scripts] from $url:"
            awk '
                /^\[project\.scripts\]/ { in_section=1; next }
                /^\[.*\]/ { in_section=0 }
                in_section && /^[^#[:space:]]/ { print "  " $0 }
            ' "$tmpfile"
            echo
            rm "$tmpfile"
        else
            echo "Failed to fetch (timeout or not found): $url"
        fi
    done
}

# === main ===
if [[ "$USE_NETWORK" == true ]]; then
	dump_scripts_section "$PYPROJECT"
	urls=$(dump_github_pyproject_urls pyproject.toml)
	fetch_and_dump_scripts_from_urls $urls
else
    if [[ ! -f "$PYPROJECT" ]]; then
        echo "pyproject.toml does not exist in current directory"
        exit 1
    fi
    dump_scripts_section "$PYPROJECT"
    dump_venv_executables
fi
