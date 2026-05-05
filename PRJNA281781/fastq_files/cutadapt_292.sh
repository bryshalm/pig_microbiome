#!/bin/bash
mkdir -p trimmed

for FQ in SRR1999228.fastq.gz SRR1999229.fastq.gz SRR1999231.fastq.gz \
          SRR1999232.fastq.gz SRR1999233.fastq.gz SRR1999235.fastq.gz \
          SRR1999236.fastq.gz SRR1999237.fastq.gz SRR1999238.fastq.gz \
          SRR1999241.fastq.gz SRR1999243.fastq.gz SRR1999245.fastq.gz \
          SRR1999247.fastq.gz; do
    SAMPLE="${FQ/.fastq.gz/}"

    cutadapt \
        -g GTGYCAGCMGCCGCGGTAA \
        -a GGACTACNVGGGTWTCTAAT \
        --discard-untrimmed \
        --minimum-length 200 \
        -o trimmed/${SAMPLE}_trimmed.fastq.gz \
        "$FQ" \
        -j 4 \
        > trimmed/${SAMPLE}_cutadapt.log 2>&1

    echo "Done: $SAMPLE"
done
