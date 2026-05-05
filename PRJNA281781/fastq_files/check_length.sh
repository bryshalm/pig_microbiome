for FQ in *.fastq.gz; do
    echo -n "$FQ: "
    zcat "$FQ" | awk 'NR%4==2 {print length($0)}' | sort -n | uniq -c | sort -rn | head -1
done
