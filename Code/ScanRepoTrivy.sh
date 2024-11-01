#!/bin/bash

# Specify the path to the folder containing Helm repositories
repo_folder="/home/kali/Desktop/SharedFiles/"

# Specify the path to the folder where scan results will be saved
output_folder="/home/kali/Desktop/output_folder/"

# Specify the names of the text files to save the lists
success_list_file="$output_folder/successful_scans.txt"
failed_list_file="$output_folder/failed_scans.txt"

# Create arrays to store successful and failed scans
success_scans=()
failed_scans=()

# Loop through each Helm repository in the specified folder
for repo_path in "$repo_folder"/*; do
    # Extract the repository name from the path
    repo_name=$(basename "$repo_path")

    # Run Trivy scan on the repository and save the output as JSON
    if trivy fs --scanners vuln,config "$repo_path" -f json -o "$output_folder/$repo_name.json"; then
        echo "Scan completed for $repo_name"
        success_scans+=("$repo_name")
    else
        echo "Failed to scan $repo_name"
        failed_scans+=("$repo_name")
    fi
done

# Save lists of successful and failed scans into text files
echo -e "Successful Scans:\n${success_scans[@]}" > "$success_list_file"
echo -e "Failed Scans:\n${failed_scans[@]}" > "$failed_list_file"

echo "Lists of successful and failed scans saved:"
echo "Successful scans: $success_list_file"
echo "Failed scans: $failed_list_file"
