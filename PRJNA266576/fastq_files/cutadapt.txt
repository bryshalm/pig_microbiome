cutadapt \
    -g GGAGGCAGCAG \
    -a ATTARAWACCCBNGTAGTCC \
    --rc \
    --discard-untrimmed \
    --minimum-length 200 \
    -o trimmed/${SAMPLE}_trimmed.fastq.gz \
    ${SAMPLE}.fastq.gz \
    -j 4 \
    > trimmed/${SAMPLE}_cutadapt.log 2>&1
