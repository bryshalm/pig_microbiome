mkdir -p trimmed

for FQ in *.fastq.gz; do
    SAMPLE="${FQ/.fastq.gz/}"

    cutadapt \
        -g CCTACGGGAGGCAGCAG \
        -a GACTACNVGGGTWTCTAAT \
        --rc \
        --minimum-length 50 \
        -o trimmed/${SAMPLE}_trimmed.fastq.gz \
        "$FQ" \
        -j 4 \
        > trimmed/${SAMPLE}_cutadapt.log 2>&1

    echo "Done: $SAMPLE"
done
