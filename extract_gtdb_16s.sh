#!/usr/bin/env bash
set -euo pipefail

CONFIG=extract_gtdb_16s.yaml

INPUT=$(yq r "$CONFIG" input_fasta)
OUTPUT=$(yq r "$CONFIG" output_fasta)

# Join search terms with |
PATTERN=$(yq r "$CONFIG" search_terms | paste -sd'|' -)

echo "INPUT=$INPUT"
echo "OUTPUT=$OUTPUT"
echo "PATTERN=$PATTERN"

awk "/^>/{p=0} /^>.*($PATTERN)/{p=1} p" \
  "$INPUT" > "$OUTPUT"
