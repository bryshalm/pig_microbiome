#!/usr/bin/env bash
# Downloads all FASTQ files from EBI SRA using parallel wget jobs.
# Usage: bash download_samples.sh
# Optional: set JOBS env var to control parallelism (default: 4)
#   JOBS=8 bash download_samples.sh

set -euo pipefail

OUTDIR="fastq_files"
JOBS="${JOBS:-4}"

mkdir -p "$OUTDIR"

URLS=(
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772065/C4_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772063/C2_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772070/C10_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772077/C17_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772071/C11_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772081/C21_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772067/C7_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772074/C14_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772069/C9_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772079/C19_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772072/C12_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772064/C3_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772083/C23_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772062/C1_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772075/C15_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772080/C20_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772076/C16_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772071/C11_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772084/C24_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772073/C13_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772078/C18_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772066/C6_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772068/C8_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772070/C10_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772063/C2_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772077/C17_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772081/C21_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772082/C22_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772065/C4_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772069/C9_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772074/C14_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772067/C7_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772079/C19_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772062/C1_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772064/C3_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772083/C23_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772072/C12_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772080/C20_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772076/C16_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772078/C18_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772082/C22_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772075/C15_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772068/C8_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772073/C13_R2.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772084/C24_R1.gz"
"ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR772/ERR772066/C6_R1.gz"
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
