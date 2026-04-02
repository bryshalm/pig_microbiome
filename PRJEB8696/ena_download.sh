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
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772077/ERR772077_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772081/ERR772081_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772065/ERR772065_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772066/ERR772066_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772074/ERR772074_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772076/ERR772076_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772078/ERR772078_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772084/ERR772084_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772082/ERR772082_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772075/ERR772075_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772064/ERR772064_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772067/ERR772067_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772069/ERR772069_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772073/ERR772073_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772084/ERR772084_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772062/ERR772062_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772070/ERR772070_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772067/ERR772067_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772083/ERR772083_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772071/ERR772071_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772075/ERR772075_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772068/ERR772068_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772064/ERR772064_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772072/ERR772072_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772080/ERR772080_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772078/ERR772078_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772081/ERR772081_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772063/ERR772063_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772066/ERR772066_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772079/ERR772079_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772076/ERR772076_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772070/ERR772070_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772063/ERR772063_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772071/ERR772071_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772074/ERR772074_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772068/ERR772068_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772082/ERR772082_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772079/ERR772079_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772077/ERR772077_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772065/ERR772065_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772069/ERR772069_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772073/ERR772073_1.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772072/ERR772072_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772080/ERR772080_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772062/ERR772062_2.fastq.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR772/ERR772083/ERR772083_1.fastq.gz"
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
