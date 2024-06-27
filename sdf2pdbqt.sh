#!/bin/bash

# Check if the input directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory-with-sdf-files>"
  exit 1
fi

# Directory containing the SDF files
INPUT_DIR="$1"

# Check if the input directory exists
if [ ! -d "$INPUT_DIR" ]; then
  echo "Directory $INPUT_DIR does not exist."
  exit 1
fi

# Create an output directory
OUTPUT_DIR="${INPUT_DIR}/pdbqt_files"
mkdir -p "$OUTPUT_DIR"

# Loop through each SDF file in the input directory
for sdf_file in "$INPUT_DIR"/*.sdf; do
  # Check if there are no SDF files
  if [ ! -e "$sdf_file" ]; then
    echo "No SDF files found in $INPUT_DIR."
    exit 1
  fi

  # Get the base name of the file (without directory and extension)
  base_name=$(basename "$sdf_file" .sdf)

  # Define the output file name
  pdbqt_file="${OUTPUT_DIR}/${base_name}.pdbqt"

  # Convert the SDF file to PDBQT format using Open Babel
  obabel "$sdf_file" -O "$pdbqt_file"

  # Check if the conversion was successful
  if [ $? -eq 0 ]; then
    echo "Converted $sdf_file to $pdbqt_file"
  else
    echo "Failed to convert $sdf_file"
  fi
done

echo "Conversion process completed."

