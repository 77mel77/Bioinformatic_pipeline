./02_process.sh samples_list.txt /home/fc66436/Project_ibbc_Melanie_Herrera/results/
Procesando muestra: Arabidopsis
Specified output directory '/home/fc66436/Project_ibbc_Melanie_Herrera/results//qc_raw' does not exist
Detecting adapter sequence for read1...
No adapter detected for read1

Detecting adapter sequence for read2...
No adapter detected for read2

ERROR: Failed to write: /home/fc66436/Project_ibbc_Melanie_Herrera/results//fastp/Arabidopsis_R1.clean.fastq.gz
Finalizado: Arabidopsis
Procesando muestra: SRR5201683
Specified output directory '/home/fc66436/Project_ibbc_Melanie_Herrera/results//qc_raw' does not exist
Detecting adapter sequence for read1...
>Illumina TruSeq Adapter Read 2
AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

Detecting adapter sequence for read2...
>Illumina TruSeq Adapter Read 1
AGATCGGAAGAGCACACGTCTGAACTCCAGTCA

ERROR: Failed to write: /home/fc66436/Project_ibbc_Melanie_Herrera/results//fastp/SRR5201683_R1.clean.fastq.gz
Finalizado: SRR5201683
Procesando muestra: SRR5602600
Specified output directory '/home/fc66436/Project_ibbc_Melanie_Herrera/results//qc_raw' does not exist
Detecting adapter sequence for read1...
No adapter detected for read1

Detecting adapter sequence for read2...
No adapter detected for read2

ERROR: Failed to write: /home/fc66436/Project_ibbc_Melanie_Herrera/results//fastp/SRR5602600_R1.clean.fastq.gz
Finalizado: SRR5602600
Procesando muestra: SRR5803928
Specified output directory '/home/fc66436/Project_ibbc_Melanie_Herrera/results//qc_raw' does not exist
Detecting adapter sequence for read1...
No adapter detected for read1

Detecting adapter sequence for read2...
No adapter detected for read2

ERROR: Failed to write: /home/fc66436/Project_ibbc_Melanie_Herrera/results//fastp/SRR5803928_R1.clean.fastq.gz
Finalizado: SRR5803928
Pipeline completado: Tue Dec  9 09:11:58 PM UTC 2025
#Creating structure of project

PROJECT_NAME="Project_ibbc_Melanie_Herrera"

BASE_DIR="$HOME/$PROJECT_NAME"

/home/melanie/Project_ibbc_Melanie_Herrera

echo "Creating project structure: $BASE_DIR"

#logs and data
mkdir -p "$BASE_DIR"/{raw_data,genome,logs,scripts}

#qc and trimming

mkdir -p "$BASE_DIR"/qc/{prefastp,postfastp,multiqc}

#fastp
mkdir -p "$BASE_DIR/fastp"

#organelle	
mkdir -p "$BASE_DIR"/organelle/{assemblies,mitofish}


