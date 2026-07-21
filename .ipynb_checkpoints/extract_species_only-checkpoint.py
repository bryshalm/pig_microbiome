#!/usr/bin/env python3

import argparse
import re
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

def main():
    parser = argparse.ArgumentParser(
        description="Extract species-only FASTA from GTDB SSU database"
    )
    parser.add_argument(
        "-i", "--input",
        required=True,
        help="Input FASTA file (e.g., bac120_ssu_reps_GTDB.fna)"
    )
    parser.add_argument(
        "-o", "--output",
        default="species_only.fna",
        help="Output FASTA file (.fna)"
    )
    args = parser.parse_args()

    records = []
    count = 0

    for seq in SeqIO.parse(args.input, "fasta"):
        count += 1
        header = seq.id

        if len(header.split(";")) < 7:
            species = "unclassified species"
            seq_id = f"UNKNOWN_{count}"
        else:
            sp = header.split(";")[6]
            sp_seq_id = re.split(r"\(|\)", sp)

            species = sp_seq_id[0] or "unclassified species"
            species = species.replace("_", " ", 2)
            species = species.replace('"', "").replace("'", "")

            seq_id = sp_seq_id[1] if len(sp_seq_id) > 1 else f"UNKNOWN_{count}"

        new_record = SeqRecord(
            seq.seq,
            id=seq_id,
            description=species
        )

        records.append(new_record)

    SeqIO.write(records, args.output, "fasta")

    print(f"Wrote {len(records)} sequences to {args.output}")

if __name__ == "__main__":
    main()
