#!/bin/bash
# Pipeline de QC + trimming + organelle

if [ -z "$1" ]; then
    echo "Usage: $0 <project_directory> [--overwrite]"
    exit 1
fi

PROJECT_DIR=$1
OVERWRITE_FLAG=""
if [ "$2" == "--overwrite" ]; then
    OVERWRITE_FLAG="--overwrite"
fi

SAMPLES_FILE="$PROJECT_DIR/raw_data/samples.txt"
OUTDIR="$PROJECT_DIR/results"
LOGFILE="$PROJECT_DIR/logs/pipeline.log"
THREADS=8

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
if [ ! -z "$OVERWRITE_FLAG" ]; then
    echo "Overwrite flag is set. Existing getorganelle directories will be overwritten." >> "$LOGFILE"
fi

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
    INPUT_FILE_R1="$R1_PATH"
    INPUT_FILE_R2="$R2_PATH"
    OUT_FILE_R1="$OUTDIR/fastp/${SAMPLE}_R1.clean.fastq.gz"
    OUT_FILE_R2="$OUTDIR/fastp/${SAMPLE}_R2.clean.fastq.gz"
    REPORT_HTML="$OUTDIR/fastp/${SAMPLE}_fastp.html"
    REPORT_JSON="$OUTDIR/fastp/${SAMPLE}_fastp.json"

    fastp \
      -i "$INPUT_FILE_R1" \
      -I "$INPUT_FILE_R2" \
      -o "$OUT_FILE_R1" \
      -O "$OUT_FILE_R2" \
      -q 30 \
      -l 50 \
      --cut_front \
      --cut_tail \
      --overrepresentation_analysis \
      -h "$REPORT_HTML" \
      -j "$REPORT_JSON" 2>&1 | tee -a "$LOGFILE"

    # 3. Organelle assembly with getorganelle
    echo "Running getorganelle for $SAMPLE" >> "$LOGFILE"
    GETORGANELLE_OUTPUT_DIR="$OUTDIR/organelle/${SAMPLE}_organelle"
    # No need to mkdir -p here, getorganelle handles it

    # Using provided getorganelle parameters
    get_organelle_from_reads.py \
      -1 "$OUTDIR/fastp/${SAMPLE}_R1.clean.fastq.gz" \
      -2 "$OUTDIR/fastp/${SAMPLE}_R2.clean.fastq.gz" \
      -R 10 \
      -k 21,45,65,85,105 \
      -F animal_mt \
      -t "$THREADS" \
      -o "$GETORGANELLE_OUTPUT_DIR" \
      $OVERWRITE_FLAG 2>&1 | tee -a "$LOGFILE"

    # Basic check for getorganelle output
    if [ -d "$GETORGANELLE_OUTPUT_DIR" ] && [ "$(ls -A "$GETORGANELLE_OUTPUT_DIR")" ]; then
        echo "getorganelle output found for $SAMPLE in $GETORGANELLE_OUTPUT_DIR" >> "$LOGFILE"
    else
        echo "WARNING: getorganelle may have failed or produced no output for $SAMPLE" >> "$LOGFILE"
    fi

    echo "Finished processing: $SAMPLE" | tee -a "$LOGFILE"
done < "$SAMPLES_FILE"

echo "Pipeline finished: $(date)" >> "$LOGFILE"
