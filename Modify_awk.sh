#!/bin/bash

# Set the input file and column to modify
input_file="datasetTemp.txt"
column=2

# Read the input file and select the specified column
awk -F ";" -v col="$column" '{print $col}' "$input_file"

# Modify the values in the specified column
awk -F ";" -v col="$column" '{$col=$col+1; print}' "$input_file"

# Write the modified values back to the input file
awk -F ";" -v col="$column" '{$col=$col+1; print}' "$input_file" > temp.csv && mv temp.csv "$input_file"

# Print the modified input file
cat "$input_file"
