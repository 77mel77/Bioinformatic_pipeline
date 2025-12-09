#!/bin/bash
# Creat project structure

PROJECT_NAME="Project_ibbc_Melanie_Herrera"
BASE_DIR="$HOME/$PROJECT_NAME"

echo "Creating project structure: $BASE_DIR"

# logs y datos
mkdir -p "$BASE_DIR"/{raw_data,genome,logs,scripts}

# QC y trimming
mkdir -p "$BASE_DIR"/results/{qc_raw,fastp,organelle}

# organelle subcarpetas
mkdir -p "$BASE_DIR"/results/organelle/{assemblies,mitofish}

echo "Project structure created successfully."
