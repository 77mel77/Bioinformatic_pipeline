# Bioinformatics Workflow for Next-Generation Sequencing Data

## Introduction

This repository contains a simplified bioinformatics workflow designed for processing Next-Generation Sequencing (NGS) data, specifically for a presentation or demonstration of key steps like quality control (FastQC), adapter and quality trimming (fastp), and organelle genome assembly (getorganelle - placeholder). The workflow is structured into three interconnected shell scripts, making it easy to understand and execute.

## Workflow Overview

The workflow consists of the following scripts, designed to be run sequentially from the project's root directory:

1.  **`script1_create_project.sh`**: Initializes the project's directory structure. This script will also prompt you to either generate dummy FASTQ.gz files for a demonstration or to use your own data.
2.  **`script3_annotate_data.sh`**: Scans the `raw_data` directory, identifies paired-end FASTQ files, and generates a `samples.txt` file. This file lists all samples to be processed by the main pipeline.
3.  **`script4_run_pipeline.sh`**: Executes the core bioinformatics pipeline, including FastQC for quality assessment, fastp for trimming, and includes a placeholder for `getorganelle` for organelle genome assembly.

## Dependencies

To run this workflow, you will need the following bioinformatics tools installed and accessible in your system's PATH:

*   **`FastQC`**: A quality control tool for high throughput sequence data.
    *   [Official Website](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
*   **`fastp`**: A ultra-fast all-in-one FASTQ preprocessor (QC/trimming/filtering/splitting/merging...).
    *   [Official Website](https://github.com/OpenGene/fastp)
*   **`getorganelle`**: A versatile tool to extract organelle genomes from NGS data.
    *   [Official Website](https://github.com/Kinggerm/GetOrganelle)

Please refer to the official documentation of each tool for detailed installation instructions. A common way to install these tools is via Miniconda/Conda.

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

The workflow scripts (`script1_create_project.sh`, `script3_annotate_data.sh`, `script4_run_pipeline.sh`) are expected to reside in the root of this `Project_ibbc_<YOUR_PROJECT_NAME>` directory or be called from it.

## Usage

Follow these steps to run the bioinformatics workflow:

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    cd <your-repository-name>
    ```

2.  **Create the project structure and prepare data:**
    Replace `MyPresentation` with your desired project name.
    ```bash
    ./script1_create_project.sh MyPresentation
    ```
    The script will ask if you have your own data. If you say 'n', it will generate dummy FASTQ files. If you say 'y', it will skip data generation and you should place your own FASTQ files in the `raw_data` directory.

    *Note: All subsequent commands should be run from within the `Project_ibbc_MyPresentation` directory.*

3.  **Annotate the raw data:**
    This script will scan `raw_data/` and create `raw_data/samples.txt`, which lists the paired-end files for the pipeline.
    ```bash
    ./script3_annotate_data.sh
    ```

4.  **Run the bioinformatics pipeline:**
    This will execute FastQC, fastp, and the `getorganelle` placeholder.
    ```bash
    ./script4_run_pipeline.sh
    ```

## Output
