#!/bin/bash
# Creat project structure

if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

NAME="$1"
PROJECT_NAME="Project_ibbc_$NAME"
BASE_DIR="$PWD/$PROJECT_NAME"

# Verfy that the Name was include.

echo "Creating project structure: $BASE_DIR"

# logs y datos
mkdir -p "$BASE_DIR"/{raw_data,genome,logs,scripts}

# QC y trimming
mkdir -p "$BASE_DIR"/results/{qc_raw,fastp,organelle}

# organelle subcarpetas
mkdir -p "$BASE_DIR"/results/organelle/{assemblies,mitofish}

echo "Project structure created successfully."
