import pandas as pd
import os

# Load your RNA-seq table
rna_seq_SraRunTable = pd.read_csv('rna_SraRunTable.csv')
runs_to_delete = rna_seq_SraRunTable['Run'].tolist()

fastq_dir = 'fastq_files'    # change this
fastqc_dir = 'fastq_files/fastqc_output'  # change this

for run in runs_to_delete:
    files_to_delete = [
        os.path.join(fastq_dir, f'{run}.fastq'),
        os.path.join(fastq_dir, f'{run}.fastq.gz'),
        os.path.join(fastq_dir, f'{run}_1.fastq.gz'),
        os.path.join(fastq_dir, f'{run}_2.fastq.gz'),
        os.path.join(fastqc_dir, f'{run}_fastqc.html'),
        os.path.join(fastqc_dir, f'{run}_fastqc.zip'),
        os.path.join(fastqc_dir, f'{run}_1_fastqc.html'),
        os.path.join(fastqc_dir, f'{run}_1_fastqc.zip'),
        os.path.join(fastqc_dir, f'{run}_2_fastqc.html'),
        os.path.join(fastqc_dir, f'{run}_2_fastqc.zip'),
    ]
    for f in files_to_delete:
        if os.path.exists(f):
            os.remove(f)
            print(f'Deleted: {f}')
        else:
            print(f'Not found: {f}')
