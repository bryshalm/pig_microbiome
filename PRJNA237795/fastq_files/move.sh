#!/bin/bash

# Define variables
FILE_LIST="move_list.txt"      # Your text file containing filenames
DEST_DIR="other_fastq_files"  # The target directory

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Read the file list and move each file
# IFS= and -r ensure filenames with spaces are handled correctly
while IFS= read -r file; do
    if [[ -f "$file" ]]; then
        mv "$file" "$DEST_DIR/"
        echo "Moved: $file"
    else
        echo "Warning: $file not found"
    fi
done < "$FILE_LIST"
