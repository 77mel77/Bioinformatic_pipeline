#!/bin/bash

# ================================
# Pipeline reproducible para FASTQ pareados
# ================================
# Uso:
#   ./run_pipeline.sh samples_list.txt output_dir
#
# 
#   samples_list.txt -> archivo con rutas de los FASTQ (R1 y R2 por línea)
#   output_dir       -> carpeta donde guardar resultados
#
# Ejemplo de samples_list.txt:
#   sample1_R1.fastq.gz sample1_R2.fastq.gz
#   sample2_R1.fastq.gz sample2_R2.fastq.gz
# ================================

# --- Configuración general ---
SAMPLES_FILE=$1
OUTDIR=$2
LOGFILE="${OUTDIR}/pipeline.log"

# Parámetros ajustables
THREADS=8
TRIM_PARAMS="--detect_adapter_for_pe -q 20 -l 50"
GETORG_PARAMS="-R 15 -k 21,45,65,85,105"

# Crear carpeta de salida
mkdir -p "$OUTDIR"

# Registrar inicio
echo "Pipeline iniciado: $(date)" > "$LOGFILE"
echo "Usando $THREADS " >> "$LOGFILE"

# --- Procesamiento de cada muestra ---
while read R1 R2; do
    SAMPLE=$(basename $R1 | cut -d "_" -f1)
    echo "Procesando muestra: $SAMPLE" | tee -a "$LOGFILE"

    # 1. QC inicial
    fastqc -t $THREADS -o "$OUTDIR/qc_raw" $R1 $R2 2>&1 | tee -a "$LOGFILE"

    # 2. Trimming
    fastp -i $R1 -I $R2 \
          -o "$OUTDIR/fastp/${SAMPLE}_R1.clean.fastq.gz" \
          -O "$OUTDIR/fastp/${SAMPLE}_R2.clean.fastq.gz" \
          -h "$OUTDIR/fastp/${SAMPLE}_fastp.html" \
          -j "$OUTDIR/fastp/${SAMPLE}_fastp.json" \
          $TRIM_PARAMS 2>&1 | tee -a "$LOGFILE"


    echo "Finalizado: $SAMPLE" | tee -a "$LOGFILE"
done < "$SAMPLES_FILE"

# --- Cierre ---
echo "Pipeline completado: $(date)" | tee -a "$LOGFILE"
