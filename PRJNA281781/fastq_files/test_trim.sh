# Save untrimmed reads
cutadapt \
    -g GTGYCAGCMGCCGCGGTAA \
    -a GGACTACNVGGGTWTCTAAT \
    --untrimmed-output untrimmed_test.fastq.gz \
    --minimum-length 0 \
    -o trimmed_test.fastq.gz \
    SRR1999228.fastq.gz \
    -j 4 > /dev/null 2>&1

# Check start of trimmed reads
echo "=== TRIMMED ==="
zcat trimmed_test.fastq.gz | awk 'NR%4==2' | cut -c1-30 | sort | uniq -c | sort -rn | head -5

# Check start of untrimmed reads
echo "=== UNTRIMMED ==="
zcat untrimmed_test.fastq.gz | awk 'NR%4==2' | cut -c1-30 | sort | uniq -c | sort -rn | head -5

# Check length distribution of trimmed output
echo "=== TRIMMED LENGTHS ==="
zcat trimmed_test.fastq.gz | awk 'NR%4==2 {print length($0)}' | sort -n | uniq -c | sort -rn | head -10
