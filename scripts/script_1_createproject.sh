#!/bin/bash
# Creat project structure and optionally prepare dummy data

if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

NAME="$1"
PROJECT_NAME="Project_ibbc_$NAME"
BASE_DIR="$PWD/$PROJECT_NAME"

# --- Create Project Structure ---
echo "Creating project structure: $BASE_DIR"
mkdir -p "$BASE_DIR"/{raw_data,genome,logs,scripts}
mkdir -p "$BASE_DIR"/results/{qc_raw,fastp,organelle}
mkdir -p "$BASE_DIR"/results/organelle/{assemblies,mitofish}
echo "Project structure created successfully."

# --- Ask user about dummy data ---
read -p "Do you have your own raw FASTQ data? (y/n) " has_data
if [[ "$has_data" == "y" || "$has_data" == "Y" ]]; then
    echo "Please place your raw FASTQ files in the '$BASE_DIR/raw_data' directory."
    echo "Then run 'script3_annotate_data.sh' to prepare the sample sheet."
    exit 0
fi

# --- Prepare Dummy Data ---
echo "Preparing 5 pairs of dummy FASTQ files for demonstration..."
OUTPUT_DIR="$BASE_DIR/raw_data"

# More efficient random sequence and quality generation
random_string() {
    local len=$1
    local chars=$2
    cat /dev/urandom | tr -dc "$chars" | head -c "$len"
}

generate_fastq_records() {
    local file_handle=$1
    local sample_num=$2
    local read_type=$3

    for r in {1..20}; do
        local seq
        seq=$(random_string 50 "ACGT")
        local qual
        qual=$(random_string 50 '!""#$%&'"'"'()*+,-./0123456789:;<=>?@ABCDEFGHI')

        echo "@sample${sample_num}_${read_type}_read${r}"
        echo "$seq"
        echo "+"
        echo "$qual"
    done > "$file_handle"
}

for i in {1..5}; do
    R1_FILE="$OUTPUT_DIR/sample${i}_R1.fastq"
    R2_FILE="$OUTPUT_DIR/sample${i}_R2.fastq"

    generate_fastq_records "$R1_FILE" "$i" "R1"
    generate_fastq_records "$R2_FILE" "$i" "R2"

    gzip "$R1_FILE"
    gzip "$R2_FILE"
done

echo "Created 5 dummy paired FASTQ.gz files in $OUTPUT_DIR"
