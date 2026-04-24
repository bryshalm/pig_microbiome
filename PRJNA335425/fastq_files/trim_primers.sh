mkdir -p trimmed

for R1 in *_1.fastq.gz; do
    R2="${R1/_1.fastq.gz/_2.fastq.gz}"
    SAMPLE="${R1/_1.fastq.gz/}"

    cutadapt \
        -G ATTACCGCGGCTGCTGG \
        -g CCGAGTTTGATCMTGGCTCAG \
        --discard-untrimmed \
        --minimum-length 200 \
        -o trimmed/${SAMPLE}_R1.fastq.gz \
        -p trimmed/${SAMPLE}_R2.fastq.gz \
        "$R1" "$R2" \
        -j 4 \
        > trimmed/${SAMPLE}_cutadapt.log 2>&1

    echo "Done: $SAMPLE"
done
