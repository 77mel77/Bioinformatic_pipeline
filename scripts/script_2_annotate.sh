#!/bin/bash

# This script generates a samples.txt file for the pipeline.
# It finds all R1 and R2 fastq.gz files in the specified project's raw_data directory,
# and writes the relative path to each pair of files to a new line
# in that project's raw_data/samples.txt.

if [ -z "$1" ]; then
    echo "Usage: $0 <project_directory>"
    exit 1
fi

PROJECT_DIR=$1
DATA_DIR="$PROJECT_DIR/raw_data"
OUTPUT_FILE="$DATA_DIR/samples.txt"

# Check if the raw_data directory exists
if [ ! -d "$DATA_DIR" ]; then
    echo "Error: Directory $DATA_DIR not found. Have you created the project with script1_create_project.sh?"
    exit 1
fi

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Find files and write relative paths to the output file
for R1_FILE in "$DATA_DIR"/*_R1.fastq.gz; do
    # Get the base name of the file
    BASENAME=$(basename "$R1_FILE" _R1.fastq.gz)
    R2_FILE="$DATA_DIR/${BASENAME}_R2.fastq.gz"

    # Check if the R2 file exists
    if [ -f "$R2_FILE" ]; then
        # Get relative paths from the project directory
        REL_R1_PATH=$(realpath --relative-to="$PROJECT_DIR" "$R1_FILE")
        REL_R2_PATH=$(realpath --relative-to="$PROJECT_DIR" "$R2_FILE")
        
        echo "Found pair: $REL_R1_PATH, $REL_R2_PATH"
        echo "$REL_R1_PATH $REL_R2_PATH" >> "$OUTPUT_FILE"
    fi
done

