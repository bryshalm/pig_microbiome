#!/usr/bin/env python3

import sys
import re


def parse_header(header):
    header = header.lstrip(">")

    parts = header.split(maxsplit=1)
    seq_id = parts[0]
    rest = parts[1] if len(parts) > 1 else ""

    accession = seq_id.rsplit(".", 1)[0]

    tax_match = re.search(
        r"(d__[^ ]+;p__[^ ]+;c__[^ ]+;o__[^ ]+;f__[^ ]+;g__[^ ]+;s__[^ ]*)",
        rest
    )

    if not tax_match:
        raise ValueError(f"No taxonomy found in header:\n{header}")

    taxonomy = tax_match.group(1).split(";")

    cleaned_tax = []
    genus = None
    species = None

    for rank in taxonomy:
        value = rank.split("__", 1)[1].strip()

        if rank.startswith("g__"):
            genus = value if value else None

        elif rank.startswith("s__"):
            species = value.replace(" ", "_") if value else None

        else:
            if value:
                cleaned_tax.append(value)

    # Add genus
    if genus:
        cleaned_tax.append(genus)

        # Add species safely
        if species and "_" in species:
            cleaned_tax.append(f"{genus}_{species.split('_', 1)[1]}")
        else:
            cleaned_tax.append(f"{genus}_sp")

    new_header = ">" + ";".join(cleaned_tax) + f"({accession}"
    return new_header


def convert_fasta(infile, outfile):
    with open(infile) as fin, open(outfile, "w") as fout:
        for line in fin:
            line = line.rstrip()
            if line.startswith(">"):
                fout.write(parse_header(line) + "\n")
            else:
                fout.write(line + "\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(f"Usage: {sys.argv[0]} input.fna output.fna")

    convert_fasta(sys.argv[1], sys.argv[2])
