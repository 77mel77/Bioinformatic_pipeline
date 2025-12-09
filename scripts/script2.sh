#!/bin/bash
# Pipeline de QC + trimming + organelle

SAMPLES_FILE=$1
OUTDIR=$2
LOGFILE="${OUTDIR}/pipeline.log"

THREADS=8
TRIM_PARAMS="--detect_adapter_for_pe -q 20 -l 50"
GETORG_PARAMS="-R 15 -k 21,45,65,85,105"

# Crear subcarpetas necesarias
mkdir -p "$OUTDIR/qc_raw" "$OUTDIR/fastp" "$OUTDIR/organelle"

echo "Pipeline iniciado: $(date)" > "$LOGFILE"
echo "Usando $THREADS hilos" >> "$LOGFILE"

while read R1 R2; do
    SAMPLE=$(basename $R1 | cut -d "_" -f1)
    echo "Procesando muestra: $SAMPLE" | tee -a "$LOGFILE"

    # 1. QC inicial
    fastqc -t $THREADS -o "$OUTDIR/qc_raw" $R1 $R2 2>&1 | tee -a "$LOGFILE"

    # 2. Trimming con reportes en carpeta fastp
    fastp -i $R1 -I $R2 \
          -o "$OUTDIR/fastp/${SAMPLE}_R1.clean.fastq.gz" \
          -O "$OUTDIR/fastp/${SAMPLE}_R2.clean.fastq.gz" \
          -h "$OUTDIR/fastp/${SAMPLE}_fastp.html" \
          -j "$OUTDIR/fastp/${SAMPLE}_fastp.json" \
          $TRIM_PARAMS 2>&1 | tee -a "$LOGFILE"

    # 3. Ensamblaje de organelo
    get_organelle_from_reads.py \
        -1 "$OUTDIR/fastp/${SAMPLE}_R1.clean.fastq.gz" \
        -2 "$OUTDIR/fastp/${SAMPLE}_R2.clean.fastq.gz" \
        -o "$OUTDIR/organelle/${SAMPLE}_getorg" \
        $GETORG_PARAMS -t $THREADS 2>&1 | tee -a "$LOGFILE"

    echo "Finalizado: $SAMPLE" | tee -a "$LOGFILE"
done < "$SAMPLES_FILE"

echo "Pipeline completado: $(date)" | tee -a "$LOGFILE"
