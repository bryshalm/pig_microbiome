#!/bin/bash
# File containing the list of SRA accession numbers
SRA_LIST="SRR_Acc_List.txt"
# Directory for output files
OUT_DIR="fastq_files"
mkdir -p "$OUT_DIR"

# Loop through each accession number in the list
while IFS= read -r accession; do
  echo "Processing $accession"
  # Use prefetch to download the .sra file (optional, fasterq-dump can do it in one go)
  # prefetch "$accession" 

  # Use fasterq-dump to download and convert to fastq format directly
  # The --split-files flag is crucial for paired-end data
  fasterq-dump --split-files -O "$OUT_DIR" "$accession"
done < "$SRA_LIST"
