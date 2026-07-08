#!/bin/bash
mkdir -p trimmed

for R1 in *_1.fastq.gz; do
    R2="${R1/_1.fastq.gz/_2.fastq.gz}"
    SAMPLE="${R1/_1.fastq.gz/}"

    cutadapt \
        -g CCTACGGGAGGCAGCAG \
        -G GGACTACNVGGGTWTCTAAT \
        --discard-untrimmed \
        -o trimmed/${SAMPLE}_1_trimmed.fastq.gz \
        -p trimmed/${SAMPLE}_2_trimmed.fastq.gz \
        "$R1" "$R2" \
        -j 4 \
        > trimmed/${SAMPLE}_cutadapt.log 2>&1

    echo "Done: $SAMPLE"
done
