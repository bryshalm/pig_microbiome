#!/usr/bin/env python3

import argparse
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

def remove_species(input_fna, output_fna):
    new_records = []

    for record in SeqIO.parse(input_fna, "fasta"):
        header = record.id

        parts = header.split(";")

        if len(parts) < 6:
            # No genus info, keep original
            new_header = header
        else:
            # Keep up to genus (6th element)
            genus_part = parts[5]

            # Keep accession info in parentheses if it exists
            if "(" in parts[-1]:
                accession = parts[-1].split("(", 1)[-1]
                new_header = ";".join(parts[:6]) + "(" + accession
            else:
                new_header = ";".join(parts[:6])

        # Create new SeqRecord with modified header
        new_record = SeqRecord(
            seq=record.seq,
            id=new_header,
            description=""  # DADA2 doesn’t need description
        )
        new_records.append(new_record)

    SeqIO.write(new_records, output_fna, "fasta")
    print(f"Wrote {len(new_records)} sequences to {output_fna}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Remove species from GTDB-style .fna for DADA2 genus-level reference")
    parser.add_argument("-i", "--input", required=True, help="Input FASTA file (.fna)")
    parser.add_argument("-o", "--output", required=True, help="Output genus-level FASTA file (.fna)")
    args = parser.parse_args()

    remove_species(args.input, args.output)
