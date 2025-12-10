#!/bin/bash
# Pipeline de QC + trimming + organelle

if [ -z "$1" ]; then
    echo "Usage: $0 <project_directory>"
    exit 1
fi

PROJECT_DIR=$1
SAMPLES_FILE="$PROJECT_DIR/raw_data/samples.txt"
OUTDIR="$PROJECT_DIR/results"
LOGFILE="$PROJECT_DIR/logs/pipeline.log"
THREADS=8
TRIM_PARAMS="--detect_adapter_for_pe -q 20 -l 50"

# --- Check for dependencies ---
if [ ! -f "$SAMPLES_FILE" ]; then
    echo "Error: Samples file not found at $SAMPLES_FILE"
    echo "Please run script3_annotate_data.sh first."
    exit 1
fi

# --- Create necessary subdirectories ---
mkdir -p "$OUTDIR/qc_raw" "$OUTDIR/fastp" "$OUTDIR/organelle" "$PROJECT_DIR/logs"

# --- Start logging ---
echo "Pipeline started: $(date)" > "$LOGFILE"
echo "Using $THREADS threads" >> "$LOGFILE"

# --- Process each sample ---
while read -r R1 R2; do
    # Since samples.txt is now created by script3, the paths should be relative to the project dir
    R1_PATH="$PROJECT_DIR/$R1"
    R2_PATH="$PROJECT_DIR/$R2"
    SAMPLE=$(basename "$R1" | cut -d "_" -f1)
    echo "Processing sample: $SAMPLE" | tee -a "$LOGFILE"

    # 1. Initial QC
    echo "Running FastQC for $SAMPLE" >> "$LOGFILE"
    fastqc -t "$THREADS" -o "$OUTDIR/qc_raw" "$R1_PATH" "$R2_PATH" 2>&1 | tee -a "$LOGFILE"

    # 2. Trimming with fastp
    echo "Running fastp for $SAMPLE" >> "$LOGFILE"
    fastp -i "$R1_PATH" -I "$R2_PATH" \
          -o "$OUTDIR/fastp/${SAMPLE}_R1.clean.fastq.gz" \
          -O "$OUTDIR/fastp/${SAMPLE}_R2.clean.fastq.gz" \
          -h "$OUTDIR/fastp/${SAMPLE}_fastp.html" \
          -j "$OUTDIR/fastp/${SAMPLE}_fastp.json" \
          "$TRIM_PARAMS" 2>&1 | tee -a "$LOGFILE"

    # 3. Organelle assembly with getorganelle
    echo "Running getorganelle for $SAMPLE" >> "$LOGFILE"
    GETORGANELLE_OUTPUT_DIR="$OUTDIR/organelle/${SAMPLE}_organelle"
    mkdir -p "$GETORGANELLE_OUTPUT_DIR"

    # Using embplant_mt for demonstration. Consider making this configurable for real applications.
    getorganelle -F embplant_mt -o "$GETORGANELLE_OUTPUT_DIR" \
                  -R "$OUTDIR/fastp/${SAMPLE}_R1.clean.fastq.gz","$OUTDIR/fastp/${SAMPLE}_R2.clean.fastq.gz" \
                  2>&1 | tee -a "$LOGFILE"

    # Basic check for getorganelle output
    if [ -d "$GETORGANELLE_OUTPUT_DIR" ] && [ "$(ls -A "$GETORGANELLE_OUTPUT_DIR")" ]; then
        echo "getorganelle output found for $SAMPLE in $GETORGANELLE_OUTPUT_DIR" >> "$LOGFILE"
    else
        echo "WARNING: getorganelle may have failed or produced no output for $SAMPLE" >> "$LOGFILE"
    fi

    echo "Finished processing: $SAMPLE" | tee -a "$LOGFILE"
done < "$SAMPLES_FILE"

