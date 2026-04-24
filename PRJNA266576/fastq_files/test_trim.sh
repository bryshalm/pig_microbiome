cutadapt \
    -g CCTACGGGAGGCAGCAG \
    -a GACTACNVGGGTWTCTAAT \
    --rc \
    --discard-untrimmed \
    --minimum-length 0 \
    -o trimmed/SRR1687004_trimmed.fastq.gz \
    SRR1687004.fastq.gz \
    -j 4 \
    > trimmed/SRR1687004_cutadapt.log 2>&1
