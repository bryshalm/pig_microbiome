vsearch --usearch_global asv_lookup_master.fasta \
  --db /home/brymoore/wsg_gtdb_tax/curated_GTDB/ssu_all_r226.fna \
  --id 0.97 \
  --strand both \
  --top_hits_only \
  --uc closed_ref_map.uc \
  --notmatched unmatched_asvs.fasta \
  --threads 8
