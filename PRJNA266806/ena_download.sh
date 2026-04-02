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
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/009/SRR1655079/SRR1655079.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/002/SRR1655082/SRR1655082.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1655185/SRR1655185.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/000/SRR1655000/SRR1655000.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/008/SRR1655138/SRR1655138.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/006/SRR1655176/SRR1655176.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1655141/SRR1655141.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1655073/SRR1655073.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/009/SRR1655069/SRR1655069.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1654663/SRR1654663.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/007/SRR1655137/SRR1655137.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/000/SRR1655140/SRR1655140.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1655081/SRR1655081.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/008/SRR1655088/SRR1655088.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1655175/SRR1655175.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/007/SRR1655147/SRR1655147.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/008/SRR1655068/SRR1655068.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/006/SRR1655136/SRR1655136.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1655161/SRR1655161.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/008/SRR1655168/SRR1655168.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/007/SRR1655087/SRR1655087.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/004/SRR1655074/SRR1655074.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/002/SRR1655142/SRR1655142.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/000/SRR1655080/SRR1655080.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/000/SRR1655180/SRR1655180.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/006/SRR1655086/SRR1655086.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/006/SRR1655186/SRR1655186.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/000/SRR1655160/SRR1655160.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/004/SRR1655144/SRR1655144.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/006/SRR1655076/SRR1655076.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/008/SRR1654658/SRR1654658.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1654661/SRR1654661.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/002/SRR1655182/SRR1655182.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1655181/SRR1655181.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/002/SRR1655162/SRR1655162.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1655143/SRR1655143.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1655085/SRR1655085.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/009/SRR1655179/SRR1655179.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/006/SRR1654656/SRR1654656.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/009/SRR1655139/SRR1655139.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/002/SRR1654662/SRR1654662.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/006/SRR1655146/SRR1655146.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/004/SRR1655184/SRR1655184.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1655071/SRR1655071.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/008/SRR1654988/SRR1654988.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/009/SRR1655059/SRR1655059.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/008/SRR1655058/SRR1655058.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1654993/SRR1654993.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1655183/SRR1655183.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1655145/SRR1655145.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/007/SRR1655177/SRR1655177.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1655083/SRR1655083.fastq.gz"
    "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/000/SRR1655070/SRR1655070.fastq.gz"
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
