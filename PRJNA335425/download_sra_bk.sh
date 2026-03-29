#!/bin/bash
SRA_LIST="SRR_Acc_List.txt"
OUT_DIR="fastq_files"
SPLIT_DIR="fastq_files/split"
mkdir -p "$OUT_DIR"
mkdir -p "$SPLIT_DIR"

while IFS= read -r accession; do
    echo "Processing $accession..."
    fasterq-dump -O "$OUT_DIR" "$accession"
    
    echo "Splitting $accession..."
    seqtk seq -1 "$OUT_DIR/${accession}.fastq" | gzip > "$SPLIT_DIR/${accession}_1.fastq.gz"
    seqtk seq -2 "$OUT_DIR/${accession}.fastq" | gzip > "$SPLIT_DIR/${accession}_2.fastq.gz"
    
    # Verify
    r1=$(zcat "$SPLIT_DIR/${accession}_1.fastq.gz" | wc -l)
    r2=$(zcat "$SPLIT_DIR/${accession}_2.fastq.gz" | wc -l)
    echo "$accession: R1=$((r1/4)) reads, R2=$((r2/4)) reads"
    
    # Delete interleaved file to save disk space
    rm "$OUT_DIR/${accession}.fastq"
    
done < "$SRA_LIST"

echo "All done!"
