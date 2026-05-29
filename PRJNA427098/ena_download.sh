#!/usr/bin/env bash
# Downloads all FASTQ files from EBI SRA using parallel wget jobs.
# Usage: bash download_samples.sh
# Optional: set JOBS env var to control parallelism (default: 4)
#   JOBS=8 bash download_samples.sh

set -euo pipefail

OUTDIR="fastq_files"
JOBS="${JOBS:-4}"

mkdir -p "$OUTDIR"

URL_FILE="${1:-formatted_ena_list.txt}"   # use first arg, or default to that filename
mapfile -t URLS < <(grep -v '^\s*#' "$URL_FILE" | grep -v '^\s*$')


download_one() {
    local url="$1"
    local fname
    fname=$(basename "$url")
    local dest="$OUTDIR/$fname"

    if [[ -f "$dest" ]]; then
        echo "[SKIP] $fname already exists"
        return
    fi

    echo "[DOWN] $fname"
    wget -q --tries=3 --waitretry=5 -O "$dest" "$url" \
        && echo "[OK]   $fname" \
        || { echo "[FAIL] $fname"; rm -f "$dest"; }
}

export -f download_one
export OUTDIR

printf '%s\n' "${URLS[@]}" | xargs -P "$JOBS" -I{} bash -c 'download_one "$@"' _ {}

echo "Done. Files saved to: $OUTDIR/"
