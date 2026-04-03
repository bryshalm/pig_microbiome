#!/usr/bin/env bash
# Downloads all 53 FASTQ files from EBI SRA using parallel wget jobs.
# Usage: bash download_samples.sh
# Optional: set JOBS env var to control parallelism (default: 4)
#   JOBS=8 bash download_samples.sh

set -euo pipefail

OUTDIR="fastq_files"
JOBS="${JOBS:-4}"

mkdir -p "$OUTDIR"

URLS=(
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/006/SRR1999236/SRR1999236.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/001/SRR1999231/SRR1999231.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/008/SRR1999228/SRR1999228.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/002/SRR1999242/SRR1999242.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/004/SRR1999244/SRR1999244.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/009/SRR1999239/SRR1999239.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/001/SRR1999241/SRR1999241.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/005/SRR1999235/SRR1999235.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/003/SRR1999233/SRR1999233.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/006/SRR1999246/SRR1999246.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/003/SRR1999243/SRR1999243.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/009/SRR1999229/SRR1999229.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/002/SRR1999232/SRR1999232.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/007/SRR1999237/SRR1999237.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/000/SRR1999230/SRR1999230.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/008/SRR1999238/SRR1999238.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/000/SRR1999240/SRR1999240.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/005/SRR1999245/SRR1999245.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/007/SRR1999247/SRR1999247.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR199/004/SRR1999234/SRR1999234.fastq.gz"
)

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
