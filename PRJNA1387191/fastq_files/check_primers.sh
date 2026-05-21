for f in *.fastq.gz; do
    sample="${f/_1.fastq.gz/}"
    echo -n "$sample: "
    cutadapt \
        -g GTGYCAGCMGCCGCGGTAA \
        -G GGACTACNVGGGTWTCTAAT \
        -o /dev/null \
        -p /dev/null \
        ${sample}_1.fastq.gz \
        ${sample}_2.fastq.gz 2>&1 | grep "Reads with adapters"
done
