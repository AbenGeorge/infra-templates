#!/bin/bash

# Function to run helm template for a given YAML file
run_helm_template() {
    local yaml_file="$1"
    local output_file="${yaml_file%.yaml}_output.txt"

    # Run helm template and capture both stdout and stderr
    { helm template . --values "$yaml_file" > "$output_file"; } 2>&1

    echo "Helm template completed for $yaml_file"
    mv "$output_file" "output/"
}

# Function to check if a directory should be skipped
should_skip_directory() {
    local directory_name="$(basename "$1")"
    [ "$directory_name" == "templates" ] || [ "$directory_name" == ".git" ]
}

# Function to recursively process YAML files in a directory
process_yaml_files() {
    local directory="$1"
    local yaml_files=("$directory"/*.yaml)
    yaml_files=("${yaml_files[@]//$directory\/Chart.yaml}")

    for yaml_file in "${yaml_files[@]}"; do
        run_helm_template "$yaml_file"
    done
}

# Main script

# Get the current directory as the parent directory
parent_directory=$(pwd)

# Create the "output" folder if it doesn't exist
mkdir -p "$parent_directory/output"

# Iterate through child folders recursively
find "$parent_directory" -type d -not -path '*/.git/*' | while IFS= read -r folder; do
    if should_skip_directory "$folder"; then
        continue
    fi

    echo "Processing folder: $folder"
    process_yaml_files "$folder"
done

echo "Script completed."






