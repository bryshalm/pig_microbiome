#!/bin/bash
SRA_LIST="SRR_Acc_List.txt"
OUT_DIR="fastq_files"
mkdir -p "$OUT_DIR"

while IFS= read -r accession; do
    echo "Processing $accession..."
    
    # Download as single-end (no --split-files)
    fasterq-dump -O "$OUT_DIR" "$accession"
    
    # Compress
    gzip "$OUT_DIR/${accession}.fastq"
    
    # Verify
    count=$(zcat "$OUT_DIR/${accession}.fastq.gz" | wc -l)
    echo "$accession: $((count/4)) reads"
    
done < "$SRA_LIST"

echo "All done!"
