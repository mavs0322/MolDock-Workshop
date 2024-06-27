#!/bin/bash

# Check if the input file is provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input_smiles_file>"
  exit 1
fi

input_file=$1

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "File not found: $input_file"
  exit 1
fi

# Create an output directory if it doesn't exist
output_dir="sdf_files"
mkdir -p "$output_dir"

# Read each line from the input file
while IFS=$'\t' read -r name smiles; do
  # Skip empty lines
  if [ -z "$name" ] || [ -z "$smiles" ]; then
    continue
  fi

  # Trim leading and trailing whitespace
  name=$(echo "$name" | xargs)
  smiles=$(echo "$smiles" | xargs)
  
  # Generate the output filename
  output_file="${output_dir}/${name}.sdf"
  
  # Convert SMILES to SDF using Open Babel with 2D coordinates
  echo "Converting SMILES: '$smiles' to file: '$output_file'"
  echo "$smiles" | obabel -ismi -osdf -O "$output_file" --gen2D --title "$smiles"
  
  # Check if the conversion was successful
  if [ $? -eq 0 ]; then
    echo "Converted $smiles to $output_file"
  else
    echo "Failed to convert $smiles"
  fi
done < "$input_file"

