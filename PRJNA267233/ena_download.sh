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
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/004/SRR1653604/SRR1653604_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/006/SRR1653586/SRR1653586_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1653581/SRR1653581_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/007/SRR1653577/SRR1653577_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/004/SRR1653584/SRR1653584_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1653571/SRR1653571_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1653583/SRR1653583_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1653591/SRR1653591_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/009/SRR1653599/SRR1653599_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1653573/SRR1653573_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1653585/SRR1653585_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/000/SRR1653590/SRR1653590_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/006/SRR1653586/SRR1653586_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1653575/SRR1653575_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/002/SRR1653602/SRR1653602_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1653603/SRR1653603_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1653593/SRR1653593_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/004/SRR1653604/SRR1653604_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1653595/SRR1653595_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/000/SRR1653590/SRR1653590_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/007/SRR1653577/SRR1653577_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/009/SRR1653589/SRR1653589_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1653571/SRR1653571_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1653573/SRR1653573_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/008/SRR1653588/SRR1653588_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/007/SRR1653587/SRR1653587_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1653581/SRR1653581_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1653575/SRR1653575_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/001/SRR1653591/SRR1653591_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1653593/SRR1653593_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1653583/SRR1653583_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1653595/SRR1653595_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/002/SRR1653602/SRR1653602_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/004/SRR1653584/SRR1653584_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/008/SRR1653588/SRR1653588_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/005/SRR1653585/SRR1653585_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/009/SRR1653589/SRR1653589_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/003/SRR1653603/SRR1653603_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/009/SRR1653599/SRR1653599_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR165/007/SRR1653587/SRR1653587_2.fastq.gz"
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
