# Bioinformatics Workflow for Next-Generation Sequencing Data

## Introduction

This repository contains a simplified bioinformatics workflow designed for processing Next-Generation Sequencing (NGS) data. It's built for presentations or demonstrations of key steps like quality control (FastQC), adapter trimming (fastp), and organelle genome assembly (getorganelle). The workflow is structured into three interconnected shell scripts that operate on a project directory.

## Workflow Overview

The workflow consists of three scripts that are run from a common directory, targeting a specific project folder:

1.  **`script1_create_project.sh`**: Initializes a dedicated project directory. This script will also prompt you to either generate dummy FASTQ.gz files for a demonstration or to use your own data.
2.  **`script3_annotate_data.sh`**: Scans the specified project's `raw_data` directory, identifies paired-end FASTQ files, and generates a `samples.txt` file. This file lists all samples to be processed by the main pipeline.
3.  **`script4_run_pipeline.sh`**: Executes the core bioinformatics pipeline on the specified project directory, including FastQC, fastp, and `getorganelle`.

## Dependencies

To run this workflow, you will need the following bioinformatics tools installed and accessible in your system's PATH:

*   **`FastQC`**: A quality control tool for high throughput sequence data.
    *   [Official Website](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
*   **`fastp`**: An ultra-fast all-in-one FASTQ preprocessor.
    *   [Official Website](https://github.com/OpenGene/fastp)
*   **`getorganelle`**: A versatile tool to extract organelle genomes from NGS data.
    *   [Official Website](https://github.com/Kinggerm/GetOrganelle)

The easiest way to install these tools is via Miniconda/Conda:
```bash
conda install -c bioconda fastqc fastp getorganelle
```

## Project Structure

The `script1_create_project.sh` script will create a directory named `Project_ibbc_<YOUR_PROJECT_NAME>` with the following structure:

```
Project_ibbc_<YOUR_PROJECT_NAME>/
├── raw_data/          # Contains raw (or dummy) FASTQ files and samples.txt
├── results/
│   ├── qc_raw/        # FastQC reports for raw data
│   ├── fastp/         # fastp trimmed data, HTML and JSON reports
│   └── organelle/     # getorganelle output (assemblies, mitofish, etc.)
├── genome/            # Placeholder for reference genomes
├── logs/              # Pipeline execution logs
└── scripts/           # Placeholder for additional scripts
```

## Usage

All scripts should be run from the directory where they are located.

1.  **Clone the repository (or download the scripts):**
    ```bash
    git clone <your-repository-url>
    cd <your-repository-name> # This will be the directory where you run the scripts
    ```

2.  **Create the project structure and prepare data:**
    Replace `MyPresentation` with your desired project name.
    ```bash
    bash script1_create_project.sh MyPresentation
    ```
    The script will ask if you have your own data. If you say 'n', it will generate dummy FASTQ files inside `./Project_ibbc_MyPresentation/raw_data/`. If you say 'y', it will skip data generation, and you should place your own FASTQ files in that directory.

3.  **Annotate the raw data:**
    You must now point the annotation script to your newly created project directory.
    ```bash
    bash script3_annotate_data.sh Project_ibbc_MyPresentation
    ```

4.  **Run the bioinformatics pipeline:**
    Finally, run the main pipeline, also pointing it to your project directory.
    ```bash
    bash script4_run_pipeline.sh Project_ibbc_MyPresentation
    ```

## Output

*   **FastQC reports:** `Project_ibbc_MyPresentation/results/qc_raw/`
*   **fastp reports:** `Project_ibbc_MyPresentation/results/fastp/`
*   **getorganelle output:** `Project_ibbc_MyPresentation/results/organelle/`
*   **Pipeline logs:** `Project_ibbc_MyPresentation/logs/pipeline.log`
